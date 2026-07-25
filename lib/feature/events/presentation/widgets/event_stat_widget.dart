
import 'package:flutter/material.dart';

class EventStat extends StatelessWidget {
  const EventStat({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final statColor = color ?? Colors.white70;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: statColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statColor.withOpacity(.30),
                  ),
                ),
                child: Icon(
                  icon,
                  color: statColor,
                  size: 20,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _formatNumber(value),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.55),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    }

    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }

    return number.toString();
  }
}