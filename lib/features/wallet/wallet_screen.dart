// lib/features/wallet/wallet_screen.dart
import 'package:flutter/material.dart';
import 'widgets/balance_section.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/cards.dart';
import 'widgets/header_component.dart';
import 'widgets/quick_action.dart';
import '../../core/config/app_colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      body: Stack(
        children: [
          // 1. Conteúdo com Scroll
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  HeaderComponent(),
                  BalanceSection(),
                  QuickActions(),
                  EarningsCard(),
                  MonthGoalCard(),
                  ReceivableCard(),
                ],
              ),
            ),
          ),
          // 2. Bottom Nav Fixa
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNav(),
          ),
        ],
      ),
    );
  }
}