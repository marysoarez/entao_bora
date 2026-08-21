import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.photoUrl, this.radius = 22});

  final String? photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    if (url == null || url.isEmpty) {
      return CircleAvatar(radius: radius, child: const Icon(Icons.person));
    }

    return ClipOval(
      child: Image.network(
        url,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Avatar ERROR: $error');

          return const Icon(Icons.person);
        },
      ),
    );
  }
}
