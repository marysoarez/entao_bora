import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class CheckinButton extends StatelessWidget {
  const CheckinButton({
    super.key,
    required this.checked,
    required this.count,
    required this.loading,
    required this.onPressed,
  });

  final bool checked;
  final int count;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: checked ? DsColors.success : Colors.white24),
          foregroundColor: checked ? Colors.greenAccent : DsColors.publicText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsRadius.lg + 2),
          ),
        ),
        icon: Icon(checked ? Icons.check_circle : Icons.location_on),
        label: Text(
          checked ? 'CHEGUEI' : '($count)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
