import 'package:flutter/material.dart';

class BoraButton extends StatelessWidget {
  const BoraButton({
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
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: active
                ? const [
                    Color(0xffD32F2F),
                    Color(0xffF44336),
                  ]
                : const [
                    Color(0xff8B0000),
                    Color(0xffC62828),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(.35),
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
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          icon: Icon(
            active
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          label: Text(
            active
                ? "BORA! ($count)"
                : "ENTÃO BORA ($count)",
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