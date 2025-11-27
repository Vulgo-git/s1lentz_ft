// lib/features/auth/presentation/pages/register_screen.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../widgets/circuit_board_painter.dart';
import '../../../../shared/widgets/s1_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorRed : AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleRegister() async {
    // Validações
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('As senhas não coincidem');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('A senha deve ter pelo menos 6 caracteres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        _cpfController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSnackBar('Cadastro realizado com sucesso!', isError: false);
        
        // Voltar para login após cadastro
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        _showSnackBar(result['error'] ?? 'Erro no cadastro');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erro inesperado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [Color(0xFF0A0E15), Colors.black],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // Textura de Circuito
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: CustomPaint(
              painter: CircuitBoardPainter(),
            ),
          ),

          // Botão Voltar
          Positioned(
            top: 50,
            left: 24,
            child: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Conteúdo
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Logo S1
                  const S1Logo(
                    size: 180,
                    color: Color(0xFF00C2FF),
                  ),

                  const SizedBox(height: 30),

                  // Título
                  const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Preencha os dados para criar sua conta',
                    style: TextStyle(fontSize: 14, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 30),

                  // Formulário
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        _buildInput(
                          controller: _nameController,
                          hintText: "Nome completo",
                          icon: LucideIcons.user,
                        ),
                        const SizedBox(height: 20),

                        _buildInput(
                          controller: _emailController,
                          hintText: "E-mail",
                          icon: LucideIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // ✅ CORRIGIDO: trocado idCard por creditCard
                        _buildInput(
                          controller: _cpfController,
                          hintText: "CPF",
                          icon: LucideIcons.creditCard,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),

                        _buildInput(
                          controller: _passwordController,
                          hintText: "Senha",
                          icon: LucideIcons.lock,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onTogglePassword: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildInput(
                          controller: _confirmPasswordController,
                          hintText: "Confirmar senha",
                          icon: LucideIcons.lock,
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          onTogglePassword: () {
                            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                          },
                        ),
                        const SizedBox(height: 30),

                        // Botão Cadastrar
                        _buildRegisterButton(),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          child: const Text(
                            'Já tem uma conta? Fazer login',
                            style: TextStyle(color: AppColors.neonBlue, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: AppColors.neonBlue,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textGray),
          prefixIcon: Icon(icon, color: AppColors.textGray, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.neonBlue, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          shadowColor: AppColors.neonBlue.withOpacity(0.5),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "Cadastrar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}