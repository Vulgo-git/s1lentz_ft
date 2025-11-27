// lib/screens/pay_to_pseudonym_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../core/config/app_colors.dart';
import '../core/services/api_service.dart';
import '../shared/widgets/s1_button.dart';
import 'pix/widgets/pseudonym_header.dart';
import 'pix/widgets/official_receiver_info.dart';
import 'pix/widgets/pix_key_field.dart';
import 'pix/widgets/amount_selector.dart';
import 'pix/widgets/status_banner.dart';
import 'pix/widgets/payment_instructions.dart';
import 'pix/types/payment_status.dart';

/// Tela principal para pagamento via PIX para um pseudônimo
/// Implementa a especificação da seção 8 do documento técnico
class PayToPseudonymScreen extends StatefulWidget {
  final String chargeId; // ID da cobrança gerada pelo backend
  final String pseudonym; // ex: "Maria"
  final String officialName; // ex: "S1LENTZ TECNOLOGIAS LTDA"
  final String cnpj; // ex: "12.345.678/0001-00"
  final String pixKey; // chave PIX (celular/email/aleatoria)
  final double? amount; // valor opcional (pode ser editável)
  final bool isVip; // se o recebedor é VIP
  final String? authToken; // token de autenticação para API e WebSocket

  const PayToPseudonymScreen({
    super.key,
    required this.chargeId,
    required this.pseudonym,
    required this.officialName,
    required this.cnpj,
    required this.pixKey,
    this.amount,
    this.isVip = false,
    this.authToken,
  });

  @override
  State<PayToPseudonymScreen> createState() => _PayToPseudonymScreenState();
}

class _PayToPseudonymScreenState extends State<PayToPseudonymScreen> {
  PaymentStatus _status = PaymentStatus.waiting;
  Timer? _pollTimer;
  WebSocketChannel? _channel;
  bool _socketConnected = false;
  double? _currentAmount;
  String? _errorMessage;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.amount;
    _connectSocket();
    _startFallbackPolling();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Conecta ao WebSocket para receber atualizações em tempo real
  void _connectSocket() {
    try {
      // Construir URL do WebSocket
      final wsUrl = _buildWebSocketUrl();
      _channel = IOWebSocketChannel.connect(wsUrl);

      _channel!.stream.listen(
        (message) {
          _handleWebSocketMessage(message);
        },
        onDone: () {
          if (mounted) {
            setState(() {
              _socketConnected = false;
            });
            // Tentar reconectar após 3 segundos
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted &&
                  _status != PaymentStatus.settled &&
                  _status != PaymentStatus.failed) {
                _connectSocket();
              }
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _socketConnected = false;
            });
          }
        },
      );

      // Marcar como conectado após um pequeno delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _socketConnected = true;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _socketConnected = false;
        });
      }
    }
  }

  String _buildWebSocketUrl() {
    // Substitua pela URL real do seu backend WebSocket
    // Exemplo: ws://localhost:8000/ws?charge_id=xxx&token=yyy
    final baseUrl = 'ws://localhost:8000/ws';
    final params = <String>[
      'charge_id=${widget.chargeId}',
    ];
    if (widget.authToken != null) {
      params.add('token=${widget.authToken}');
    }
    return '$baseUrl?${params.join('&')}';
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      if (data['charge_id'] == widget.chargeId) {
        final eventType = data['type'] ?? '';
        final status = data['status'] ?? '';

        if (eventType == 'payment.settled' || status == 'SETTLED') {
          setState(() {
            _status = PaymentStatus.settled;
            _errorMessage = null;
          });
          _stopPolling();
          _showSuccessNotification();
        } else if (status == 'PENDING') {
          setState(() {
            _status = PaymentStatus.pending;
          });
        } else if (status == 'FAILED' || eventType == 'payment.failed') {
          setState(() {
            _status = PaymentStatus.failed;
            _errorMessage = data['error'] ?? 'Pagamento não realizado';
          });
          _stopPolling();
        }
      }
    } catch (e) {
      // Ignorar erros de parsing
    }
  }

  /// Polling de fallback caso WebSocket falhe
  void _startFallbackPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted &&
          (_status == PaymentStatus.waiting ||
              _status == PaymentStatus.pending)) {
        _pollStatus();
      }
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _pollStatus() async {
    if (!mounted) return;
    if (_status == PaymentStatus.settled || _status == PaymentStatus.failed) {
      _stopPolling();
      return;
    }

    try {
      final result = await ApiService.getChargeStatus(
        widget.chargeId,
        token: widget.authToken,
      );

      if (result['success'] == true && mounted) {
        final data = result['data'];
        final statusStr = (data['status'] ?? '').toString().toUpperCase();

        if (statusStr == 'SETTLED') {
          setState(() {
            _status = PaymentStatus.settled;
            _errorMessage = null;
          });
          _stopPolling();
          _showSuccessNotification();
        } else if (statusStr == 'PENDING') {
          setState(() {
            _status = PaymentStatus.pending;
          });
        } else if (statusStr == 'FAILED') {
          setState(() {
            _status = PaymentStatus.failed;
            _errorMessage = data['error'] ?? 'Pagamento não realizado';
          });
          _stopPolling();
        }
      }
    } catch (e) {
      // Ignorar erros temporários
    }
  }

  Future<void> _manualConfirm() async {
    if (_currentAmount == null || _currentAmount! <= 0) {
      _showError('Por favor, informe um valor válido');
      return;
    }

    setState(() {
      _isConfirming = true;
    });

    try {
      final result = await ApiService.confirmManualPayment(
        chargeId: widget.chargeId,
        claimedAmount: _currentAmount!,
        token: widget.authToken,
      );

      if (mounted) {
        setState(() {
          _isConfirming = false;
        });

        if (result['success'] == true) {
          final data = result['data'];
          final statusStr =
              (data['status'] ?? 'PENDING').toString().toUpperCase();

          if (statusStr == 'SETTLED') {
            setState(() {
              _status = PaymentStatus.settled;
            });
            _showSuccessNotification();
          } else {
            setState(() {
              _status = PaymentStatus.pending;
            });
            _showInfo('Pagamento confirmado. Aguardando conciliação...');
          }
        } else {
          setState(() {
            _status = PaymentStatus.pending;
          });
          _showInfo('Confirmação enviada. Aguardando verificação...');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConfirming = false;
          _status = PaymentStatus.pending;
        });
        _showInfo('Confirmação enviada. Aguardando verificação...');
      }
    }
  }

  void _showSuccessNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Pagamento recebido com sucesso!'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.neonCyan,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleReportProblem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: const Text('Reportar problema'),
        content: const Text(
          'Se você encontrou algum problema com este pagamento, entre em contato com o suporte.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Aqui você pode abrir uma tela de suporte ou enviar email
            },
            child: const Text('Abrir suporte'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        title: Text(
          'Pagar — ${widget.pseudonym}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          // Indicador de conexão WebSocket
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              _socketConnected ? Icons.wifi : Icons.wifi_off,
              color: _socketConnected
                  ? AppColors.success
                  : AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header com pseudônimo
              PseudonymHeader(
                pseudonym: widget.pseudonym,
                isVip: widget.isVip,
              ),
              const SizedBox(height: 16),

              // Informações da instituição recebedora
              OfficialReceiverInfo(
                officialName: widget.officialName,
                cnpj: widget.cnpj,
              ),
              const SizedBox(height: 16),

              // Campo da chave PIX
              PixKeyField(
                pixKey: widget.pixKey,
                maskable: true,
              ),
              const SizedBox(height: 16),

              // Seletor de valor
              AmountSelector(
                initialAmount: widget.amount,
                editable: widget.amount == null,
                onAmountChanged: (amount) {
                  setState(() {
                    _currentAmount = amount;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Instruções de pagamento
              const PaymentInstructions(),
              const SizedBox(height: 16),

              // Banner de status
              StatusBanner(
                status: _status,
                customMessage: _errorMessage,
              ),
              const SizedBox(height: 16),

              // Botão de confirmação manual
              if (_status != PaymentStatus.settled)
                S1Button(
                  text: 'Já efetuei o pagamento',
                  loading: _isConfirming,
                  onTap: _manualConfirm,
                ),
              const SizedBox(height: 12),

              // Botão cancelar
              if (_status != PaymentStatus.settled)
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.borderCyan),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),

              const SizedBox(height: 24),

              // Link para reportar problema
              Center(
                child: TextButton.icon(
                  onPressed: _handleReportProblem,
                  icon: const Icon(
                    Icons.report_problem_outlined,
                    size: 18,
                  ),
                  label: const Text('Reportar problema'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
