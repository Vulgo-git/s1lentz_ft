// lib/shared/widgets/s1_button.dart
import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class S1Button extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;

  const S1Button({
    super.key,
    required this.text,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0051A8), Color(0xFF009FFF)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}