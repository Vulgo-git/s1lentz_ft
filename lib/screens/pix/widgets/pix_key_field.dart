// lib/screens/pix/widgets/pix_key_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/config/app_colors.dart';
import '../../../shared/widgets/s1_button.dart';

/// Componente para exibir e copiar a chave PIX
class PixKeyField extends StatefulWidget {
  final String pixKey;
  final bool maskable; // Se true, permite mascarar a chave ao pressionar

  const PixKeyField({
    super.key,
    required this.pixKey,
    this.maskable = true,
  });

  @override
  State<PixKeyField> createState() => _PixKeyFieldState();
}

class _PixKeyFieldState extends State<PixKeyField> {
  bool _isMasked = false;
  bool _copied = false;
  DateTime? _maskStartTime;

  void _toggleMask() {
    setState(() {
      _isMasked = !_isMasked;
      if (_isMasked) {
        _maskStartTime = DateTime.now();
      } else {
        _maskStartTime = null;
      }
    });

    // Auto-desmascarar após 5 segundos
    if (_isMasked) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isMasked) {
          setState(() {
            _isMasked = false;
            _maskStartTime = null;
          });
        }
      });
    }
  }

  Future<void> _copyKey() async {
    await Clipboard.setData(ClipboardData(text: widget.pixKey));
    setState(() {
      _copied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  String _getDisplayKey() {
    if (widget.maskable && _isMasked) {
      return '•' * widget.pixKey.length;
    }
    return widget.pixKey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.key,
                size: 18,
                color: AppColors.neonCyan,
              ),
              const SizedBox(width: 8),
              Text(
                'Chave PIX',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  _getDisplayKey(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botão de copiar
              IconButton(
                icon: Icon(
                  _copied ? Icons.check_circle : Icons.copy,
                  color: _copied ? AppColors.success : AppColors.neonCyan,
                ),
                onPressed: _copyKey,
                tooltip: 'Copiar chave PIX',
              ),
              // Botão de mascarar (se habilitado)
              if (widget.maskable)
                IconButton(
                  icon: Icon(
                    _isMasked ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: _toggleMask,
                  tooltip: _isMasked ? 'Mostrar chave' : 'Ocultar chave',
                ),
            ],
          ),
          if (_copied)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Chave copiada!',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

