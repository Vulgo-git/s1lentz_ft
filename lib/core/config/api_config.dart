// lib/core/config/api_config.dart
/// Configuração da API
/// 
/// IMPORTANTE: Configure a URL da sua API antes de usar o aplicativo
/// 
/// Para desenvolvimento local:
/// - Android Emulador: 'http://10.0.2.2:8000/api'
/// - iOS Simulador: 'http://localhost:8000/api'
/// - Windows/Mac/Linux: 'http://localhost:8000/api'
/// 
/// Para produção:
/// - Substitua pela URL real da sua API (ex: 'https://api.s1lentz.com/api')

class ApiConfig {
  // ⚠️ CONFIGURE A URL DA SUA API AQUI
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Timeout para requisições (em segundos)
  static const int requestTimeout = 10;
  
  // Versão da API
  static const String apiVersion = 'v1';
  
  /// Retorna a URL completa do endpoint
  static String getEndpoint(String path) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$baseUrl/$apiVersion/$cleanPath';
  }
  
  /// Verifica se a API está configurada (não é placeholder)
  static bool get isConfigured {
    return !baseUrl.contains('sua-api.com') && 
           baseUrl.isNotEmpty &&
           baseUrl != 'http://localhost:8000/api'; // Ajuste conforme necessário
  }
}

