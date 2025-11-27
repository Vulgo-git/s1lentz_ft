// lib/features/wallet/widgets/cards.dart
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppColors.sectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Meus ganhos",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderCyan),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up,
                    color: AppColors.neonCyan, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                    child: Text("Hoje",
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                const Text("R\$72,50",
                    style: TextStyle(
                        color: AppColors.neonCyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MonthGoalCard extends StatelessWidget {
  const MonthGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    const double goalTotal = 5000;
    const double currentEarnings = 1356.98;
    final double progress = (currentEarnings / goalTotal).clamp(0.0, 1.0);

    return Padding(
      padding: AppColors.sectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Meta do mês",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderCyan),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.track_changes,
                            color: AppColors.neonCyan, size: 32),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Meta estipulada",
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                            Text("R\$$goalTotal",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Faltam",
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                        Text(
                            "R\$${(goalTotal - currentEarnings).toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: AppColors.neonCyan, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.darkBlue,
                                borderRadius: BorderRadius.circular(4))),
                        Container(
                            height: 8,
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                                color: AppColors.neonCyan,
                                borderRadius: BorderRadius.circular(4))),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${(progress * 100).toStringAsFixed(1)}% alcançado",
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivableCard extends StatelessWidget {
  const ReceivableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppColors.sectionPadding,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderCyan),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("A receber:",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("R\$5.200,00",
                style: TextStyle(
                    color: AppColors.neonCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}