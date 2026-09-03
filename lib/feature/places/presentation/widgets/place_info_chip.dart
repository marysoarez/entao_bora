import 'package:flutter/material.dart';

class PlaceInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const PlaceInfoChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
      ),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}