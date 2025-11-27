// lib/core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ CONFIGURE A URL DA SUA API AQUI
  // Para desenvolvimento local, use: 'http://localhost:8000/api' ou 'http://10.0.2.2:8000/api' (Android emulador)
  // Para produção, substitua pela URL real da sua API
  static const String baseUrl =
      'http://localhost:8000/api'; // ← SUBSTITUA PELA SUA URL REAL

  /// Verifica se a API está configurada corretamente
  static bool get isConfigured {
    return baseUrl != 'https://sua-api.com/api' && baseUrl.isNotEmpty;
  }

  /// Login do usuário
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      // Verificar se a URL está configurada
      if (baseUrl.contains('sua-api.com') ||
          (baseUrl.contains('localhost') && baseUrl.contains('8000'))) {
        // Em desenvolvimento, permite localhost mas avisa
        // Em produção, deve estar configurada
      }

      final response = await http
          .post(
        Uri.parse('$baseUrl/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão excedido');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Credenciais inválidas'};
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'error': 'Endpoint não encontrado. Verifique a URL da API.'
        };
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'error': errorData['message'] ?? 'Erro ao fazer login'
          };
        } catch (_) {
          return {
            'success': false,
            'error': 'Erro ao fazer login (Status: ${response.statusCode})'
          };
        }
      }
    } on FormatException {
      return {'success': false, 'error': 'Erro ao processar resposta da API'};
    } on Exception catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('Failed host lookup') ||
          errorMessage.contains('Connection refused') ||
          errorMessage.contains('Network is unreachable')) {
        return {
          'success': false,
          'error':
              'Não foi possível conectar ao servidor. Verifique sua conexão e a URL da API.'
        };
      } else if (errorMessage.contains('Tempo de conexão')) {
        return {
          'success': false,
          'error': 'Tempo de conexão excedido. Tente novamente.'
        };
      }
      return {'success': false, 'error': 'Erro de conexão: ${e.toString()}'};
    } catch (e) {
      return {'success': false, 'error': 'Erro inesperado: ${e.toString()}'};
    }
  }

  /// Registro de novo usuário
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String cpf,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'cpf': cpf,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Erro no cadastro'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: $e'};
    }
  }

  /// Enviar código de verificação
  static Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Erro ao enviar código'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: $e'};
    }
  }

  /// Verificar código
  static Future<Map<String, dynamic>> verifyCode(
      String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Código inválido'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: $e'};
    }
  }

  /// Criar cobrança PIX para receber pagamento externo
  /// Retorna: {charge_id, payment_instructions: {pix_key, amount, ...}}
  static Future<Map<String, dynamic>> createCharge({
    required double amount,
    String? memo,
    String? targetPseudonym,
    String? token,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/v1/payments/create_charge'),
        headers: headers,
        body: jsonEncode({
          'amount': amount,
          if (memo != null) 'memo': memo,
          if (targetPseudonym != null) 'target_pseud': targetPseudonym,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Erro ao criar cobrança'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: $e'};
    }
  }

  /// Verificar status de uma cobrança
  static Future<Map<String, dynamic>> getChargeStatus(
    String chargeId, {
    String? token,
  }) async {
    try {
      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/v1/payments/status/$chargeId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Erro ao verificar status'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: $e'};
    }
  }

  /// Confirmar pagamento manualmente (quando usuário clica "já efetuei o pagamento")
  static Future<Map<String, dynamic>> confirmManualPayment({
    required String chargeId,
    required double claimedAmount,
    String? token,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/v1/payments/confirm_manual'),
        headers: headers,
        body: jsonEncode({
          'charge_id': chargeId,
          'claimed_amount': claimedAmount,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Erro ao confirmar pagamento'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: $e'};
    }
  }
}
