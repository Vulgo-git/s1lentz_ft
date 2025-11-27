// lib/screens/pix/widgets/status_banner.dart
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import '../types/payment_status.dart';

/// Componente que exibe o status do pagamento com animação
class StatusBanner extends StatefulWidget {
  final PaymentStatus status;
  final String? customMessage;

  const StatusBanner({
    super.key,
    required this.status,
    this.customMessage,
  });

  @override
  State<StatusBanner> createState() => _StatusBannerState();
}

class _StatusBannerState extends State<StatusBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case PaymentStatus.settled:
        return AppColors.success;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.waiting:
        return AppColors.neonCyan;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.status) {
      case PaymentStatus.settled:
        return Icons.check_circle;
      case PaymentStatus.pending:
        return Icons.hourglass_empty;
      case PaymentStatus.failed:
        return Icons.error;
      case PaymentStatus.waiting:
        return Icons.access_time;
    }
  }

  String _getStatusText() {
    if (widget.customMessage != null) {
      return widget.customMessage!;
    }
    switch (widget.status) {
      case PaymentStatus.settled:
        return 'Pagamento recebido — saldo creditado';
      case PaymentStatus.pending:
        return 'Pagamento pendente — aguardando conciliação';
      case PaymentStatus.failed:
        return 'Pagamento não realizado / erro';
      case PaymentStatus.waiting:
        return 'Aguardando pagamento';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final icon = _getStatusIcon();
    final text = _getStatusText();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          FadeTransition(
            opacity: widget.status == PaymentStatus.waiting ||
                    widget.status == PaymentStatus.pending
                ? _fadeAnimation
                : const AlwaysStoppedAnimation(1.0),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

