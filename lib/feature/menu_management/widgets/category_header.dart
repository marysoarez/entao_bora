import 'package:flutter/material.dart';

class CategoryHeader extends StatelessWidget {
  final String title;
  final int count;

  const CategoryHeader({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Chip(
          label: Text('$count item(s)'),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}