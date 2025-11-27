// lib/core/config/app_routes.dart
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart'; // ✅ ADICIONE
import '../../features/wallet/wallet_screen.dart';
import '../../screens/pay_to_pseudonym_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String wallet = '/wallet';
  static const String vipDashboard = '/vip';
  static const String registerStep1 = '/register-step1';
  static const String registerStep2 = '/register-step2';
  static const String recover = '/recover';
  static const String payToPseudonym = '/pay-to-pseudonym';

  static Map<String, WidgetBuilder> get routes {
    return {
      initial: (context) => const LoginScreen(),
      login: (context) => const LoginScreen(),
      wallet: (context) => const WalletScreen(),
      registerStep1: (context) => const RegisterScreen(), // ✅ TELA REAL

      vipDashboard: (context) => Scaffold(
            appBar: AppBar(title: const Text('VIP (placeholder)')),
            body: const Center(child: Text('VIP Dashboard placeholder')),
          ),
      registerStep2: (context) => Scaffold(
            appBar: AppBar(title: const Text('Cadastro - Step 2')),
            body: const Center(child: Text('Register Step 2 placeholder')),
          ),
      recover: (context) => Scaffold(
            appBar: AppBar(title: const Text('Recuperar senha')),
            body: const Center(child: Text('Recover placeholder')),
          ),
      // Rota para pagamento PIX (requer argumentos via ModalRoute)
      payToPseudonym: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return PayToPseudonymScreen(
          chargeId: args['chargeId'] as String,
          pseudonym: args['pseudonym'] as String,
          officialName: args['officialName'] as String,
          cnpj: args['cnpj'] as String,
          pixKey: args['pixKey'] as String,
          amount: args['amount'] as double?,
          isVip: args['isVip'] as bool? ?? false,
          authToken: args['authToken'] as String?,
        );
      },
    };
  }

  /// Helper para navegar para a tela de pagamento PIX
  static void navigateToPayToPseudonym(
    BuildContext context, {
    required String chargeId,
    required String pseudonym,
    required String officialName,
    required String cnpj,
    required String pixKey,
    double? amount,
    bool isVip = false,
    String? authToken,
  }) {
    Navigator.pushNamed(
      context,
      payToPseudonym,
      arguments: {
        'chargeId': chargeId,
        'pseudonym': pseudonym,
        'officialName': officialName,
        'cnpj': cnpj,
        'pixKey': pixKey,
        'amount': amount,
        'isVip': isVip,
        'authToken': authToken,
      },
    );
  }
}
