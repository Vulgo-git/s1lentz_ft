// lib/features/auth/widgets/language_selector.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/app_colors.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _selectedLang = 'PT';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderDark, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF0A0E15),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.neonBlue, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: PopupMenuButton<String>(
          offset: const Offset(0, 45),
          onSelected: (value) {
            setState(() => _selectedLang = value);
          },
          itemBuilder: (context) => [
            _buildMenuItem('PT', 'Português'),
            _buildMenuItem('EN', 'English'),
            _buildMenuItem('ES', 'Español'),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedLang,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevronDown,
                    color: AppColors.textGray, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String code, String label) {
    return PopupMenuItem(
      value: code,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}