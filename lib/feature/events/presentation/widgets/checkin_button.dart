
import 'package:flutter/material.dart';

class CheckinButton extends StatelessWidget {
  const CheckinButton({super.key, 
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
          side: BorderSide(
            color: checked
                ? Colors.green
                : Colors.white24,
          ),
          foregroundColor: checked
              ? Colors.greenAccent
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: Icon(
          checked
              ? Icons.check_circle
              : Icons.location_on,
        ),
        label: Text(
          checked
              ? "CHEGUEI"
              : "($count)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
