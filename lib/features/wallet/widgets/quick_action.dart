// lib/features/wallet/widgets/quick_action.dart
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  Widget _buildActionButton(
      {required String label, required IconData icon, required bool isActive}) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isActive ? AppColors.darkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? AppColors.neonCyan : AppColors.borderCyan,
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.neonCyan : AppColors.textSecondary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppColors.sectionPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(label: "Pix", icon: Icons.pix, isActive: true),
          _buildActionButton(
              label: "Em breve", icon: Icons.close, isActive: false),
          _buildActionButton(
              label: "Em breve", icon: Icons.close, isActive: false),
          _buildActionButton(
              label: "Em breve", icon: Icons.close, isActive: false),
        ],
      ),
    );
  }
}