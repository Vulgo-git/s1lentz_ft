// lib/core/services/auth_provider.dart
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;

  /// Fazer login
  void login(String token, Map<String, dynamic> userData) {
    _token = token;
    _user = userData;
    notifyListeners();
  }

  /// Fazer logout
  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  /// Atualizar dados do usuário
  void updateUser(Map<String, dynamic> userData) {
    _user = userData;
    notifyListeners();
  }
}