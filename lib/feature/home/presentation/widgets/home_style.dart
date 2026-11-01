import 'dart:convert';
import 'package:flutter/material.dart';

part 'home_icon_vectors.dart';

abstract final class HomeStyle {
  static const background = Color(0xFF000000);
  static const text = Color(0xFFF6F4F2);
  static const accent = Color(0xFFD64545);
  static const brand = Color(0xFFE46262);
  static const muted = Color(0xFFAAAAAA);
  static const surface = Color(0xFF161616);
  static const border = Color(0xFF303030);

  static TextStyle type(
    double size, {
    Color color = text,
    FontWeight weight = FontWeight.w400,
    double? tracking,
    double? height,
  }) => TextStyle(
    fontFamily: 'Arial',
    fontFamilyFallback: const ['Helvetica', 'Arimo', 'sans-serif'],
    fontSize: size,
    color: color,
    fontWeight: weight,
    fontVariations: [
      FontVariation('wght', weight.value.clamp(400, 700).toDouble()),
    ],
    letterSpacing: tracking,
    height: height ?? 1.5,
  );
  static BoxDecoration box({
    Color color = surface,
    Color border = border,
    double radius = 10,
  }) => BoxDecoration(
    color: color,
    border: Border.all(color: border),
    borderRadius: BorderRadius.circular(radius),
  );
}

enum HomeGlyph {
  compass,
  user,
  login,
  logout,
  pin,
  search,
  sliders,
  music,
  list,
  arrow,
  calendar,
  store,
  chevron,
}

/// Outline vectors on a 24-unit canvas, keeping the Lucide stroke proportions.
class HomeIcon extends StatelessWidget {
  const HomeIcon(
    this.glyph, {
    super.key,
    this.size = 17,
    this.color = HomeStyle.text,
  });
  final HomeGlyph glyph;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _IconPainter(glyph, color)),
  );
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.glyph, this.color);
  final HomeGlyph glyph;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    _paintHomeGlyph(canvas, paint, glyph);
  }

  @override
  bool shouldRepaint(_IconPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}

class HomeAction extends StatelessWidget {
  const HomeAction(
    this.label, {
    super.key,
    required this.onTap,
    this.icon,
    this.hideLabel = false,
    this.color = HomeStyle.text,
    this.size = 13,
    this.trailingIcon = false,
    this.compact = false,
  });
  final String label;
  final VoidCallback onTap;
  final HomeGlyph? icon;
  final bool hideLabel;
  final Color color;
  final double size;
  final bool trailingIcon;
  final bool compact;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: hideLabel ? label : null,
    child: Tooltip(
      message: label,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: color,
          minimumSize: const Size(44, 48),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(vertical: compact ? 0 : 15),
          shape: const RoundedRectangleBorder(),
          textStyle: HomeStyle.type(size, color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && !trailingIcon) HomeIcon(icon!, color: color),
            if (icon != null && !hideLabel && !trailingIcon)
              const SizedBox(width: 7),
            if (!hideLabel) Flexible(child: Text(label)),
            if (icon != null && trailingIcon) ...[
              const SizedBox(width: 10),
              HomeIcon(icon!, size: 18, color: color),
            ],
          ],
        ),
      ),
    ),
  );
}

class HomeMessage extends StatelessWidget {
  const HomeMessage(this.message, {super.key, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 20),
    padding: const EdgeInsets.all(24),
    decoration: HomeStyle.box(border: const Color(0xFF353535)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: HomeStyle.type(14, color: const Color(0xFFCCCCCC)),
        ),
        if (onRetry != null) HomeAction('Tentar novamente', onTap: onRetry!),
      ],
    ),
  );
}

class HomePhoto extends StatelessWidget {
  const HomePhoto(
    this.source, {
    super.key,
    required this.height,
    this.width = double.infinity,
    this.iconSize = 48,
  });
  final String source;
  final double height, width, iconSize;
  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: const Color(0xFF222222),
      child: Center(child: HomeIcon(HomeGlyph.music, size: iconSize)),
    );
    Widget content = fallback;
    if (source.isNotEmpty) {
      try {
        content = source.startsWith('http://') || source.startsWith('https://')
            ? Image.network(
                source,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => fallback,
              )
            : Image.memory(
                source.startsWith('data:')
                    ? UriData.parse(source).contentAsBytes()
                    : base64Decode(source),
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => fallback,
              );
      } catch (_) {
        content = fallback;
      }
    }
    return SizedBox(width: width, height: height, child: content);
  }
}
