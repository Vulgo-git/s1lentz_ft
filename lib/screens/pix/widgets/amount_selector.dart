// lib/screens/pix/widgets/amount_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/config/app_colors.dart';
import '../../../shared/widgets/s1_input.dart';

/// Componente para selecionar/editar o valor do pagamento
class AmountSelector extends StatefulWidget {
  final double? initialAmount;
  final bool editable;
  final ValueChanged<double>? onAmountChanged;

  const AmountSelector({
    super.key,
    this.initialAmount,
    this.editable = true,
    this.onAmountChanged,
  });

  @override
  State<AmountSelector> createState() => _AmountSelectorState();
}

class _AmountSelectorState extends State<AmountSelector> {
  late TextEditingController _controller;
  double? _currentAmount;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.initialAmount;
    _controller = TextEditingController(
      text: widget.initialAmount != null
          ? widget.initialAmount!.toStringAsFixed(2)
          : '',
    );
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text.replaceAll(RegExp(r'[^\d,.]'), '');
    if (text.isNotEmpty) {
      try {
        final value = double.parse(text.replaceAll(',', '.'));
        if (value != _currentAmount) {
          setState(() {
            _currentAmount = value;
          });
          widget.onAmountChanged?.call(value);
        }
      } catch (e) {
        // Ignorar erros de parsing
      }
    } else {
      setState(() {
        _currentAmount = null;
      });
    }
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 18,
                color: AppColors.neonCyan,
              ),
              const SizedBox(width: 8),
              Text(
                'Valor',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.editable)
            TextFormField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
              ],
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixText: 'R\$ ',
                prefixStyle: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.borderCyan.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.borderCyan.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.neonCyan,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            )
          else
            Text(
              _currentAmount != null
                  ? _formatCurrency(_currentAmount!)
                  : 'R\$ 0,00',
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

