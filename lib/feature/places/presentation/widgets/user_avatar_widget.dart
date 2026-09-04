import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.photoUrl, this.radius = 22});

  final String? photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    if (url == null || url.isEmpty) {
      return _FallbackAvatar(radius: radius);
    }

    return ClipOval(
      child: Image.network(
        url,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (context, error, stackTrace) =>
            _FallbackAvatar(radius: radius),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: DsColors.publicText.withValues(alpha: .12),
      child: const Icon(Icons.person, color: DsColors.publicText),
    );
  }
}
