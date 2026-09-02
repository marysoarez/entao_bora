import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class BoraButton extends StatelessWidget {
  const BoraButton({
    super.key,
    required this.active,
    required this.count,
    required this.loading,
    required this.onPressed,
  });

  final bool active;
  final int count;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsRadius.lg + 2),
          gradient: LinearGradient(
            colors: active
                ? const [Color(0xFFD32F2F), Color(0xFFF44336)]
                : const [Color(0xFF8B0000), Color(0xFFC62828)],
          ),
          boxShadow: [
            BoxShadow(
              color: DsColors.accent.withValues(alpha: .35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: DsColors.publicText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DsRadius.lg + 2),
            ),
          ),
          icon: Icon(active ? Icons.favorite : Icons.favorite_border),
          label: Text(
            active ? 'BORA! ($count)' : 'ENTAO BORA ($count)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
