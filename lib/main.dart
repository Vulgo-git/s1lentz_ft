// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/config/app_colors.dart';
import 'core/config/app_routes.dart';
import 'themes/dark_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração do sistema UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.midnight,
  ));

  // Opcional: travar orientação se necessário
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const S1LENTZApp());
}

class S1LENTZApp extends StatelessWidget {
  const S1LENTZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S1LENTZ',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      initialRoute: AppRoutes.login, // ✅ Inicia no login
      routes: AppRoutes.routes,

      // Adicionar fallback para rotas não encontradas
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Página não encontrada: ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}