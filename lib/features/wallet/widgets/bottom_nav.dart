// lib/features/wallet/widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  Widget _buildNavItem(
      {required IconData icon, required String label, required bool isActive}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: isActive ? AppColors.neonCyan : AppColors.textSecondary,
            size: 24),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                color: isActive ? AppColors.neonCyan : AppColors.textSecondary,
                fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF001433),
        border: Border(top: BorderSide(color: AppColors.borderCyan)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
              icon: Icons.home_filled, label: "Início", isActive: true),
          _buildNavItem(
              icon: Icons.description_outlined,
              label: "Extrato",
              isActive: false),
          _buildNavItem(
              icon: Icons.account_balance_wallet_outlined,
              label: "Carteira",
              isActive: false),
        ],
      ),
    );
  }
}