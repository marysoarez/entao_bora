import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

/// Canvas transcription of the reference SVG, in its original 42 × 48 space.
Future<google.BitmapDescriptor> halloweenPin(int count, double density) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(density);
  final body = Path()
    ..moveTo(21, 47)
    ..cubicTo(17, 40, 5, 31, 5, 19)
    ..arcToPoint(
      const Offset(37, 19),
      radius: const Radius.circular(16),
      largeArc: true,
    )
    ..cubicTo(37, 31, 25, 40, 21, 47)
    ..close();
  canvas.drawPath(body, Paint()..color = const Color(0xFF101010));
  canvas.drawPath(
    body,
    Paint()
      ..color = const Color(0xFFFF8A3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
  canvas.drawPath(
    Path()
      ..moveTo(19, 9)
      ..cubicTo(19, 6, 21, 4, 24, 4)
      ..cubicTo(23, 6, 23, 8, 25, 10)
      ..close(),
    Paint()..color = const Color(0xFFFF8A3D),
  );
  canvas.drawPath(
    Path()
      ..moveTo(21, 11)
      ..cubicTo(29, 11, 33, 15, 33, 21)
      ..cubicTo(33, 27, 29, 32, 21, 32)
      ..cubicTo(13, 32, 9, 27, 9, 21)
      ..cubicTo(9, 15, 13, 11, 21, 11)
      ..close(),
    Paint()..color = const Color(0xFFE86F24),
  );
  canvas.drawPath(
    Path()
      ..moveTo(15, 18)
      ..lineTo(19, 21)
      ..lineTo(13, 21)
      ..close()
      ..moveTo(27, 18)
      ..lineTo(29, 21)
      ..lineTo(23, 21)
      ..close()
      ..moveTo(16, 26)
      ..lineTo(26, 26)
      ..lineTo(24, 29)
      ..lineTo(18, 29)
      ..close(),
    Paint()..color = const Color(0xFF19130F),
  );
  if (count > 1) {
    final text = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(21 - text.width / 2, 38 - text.height / 2));
  }
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    (42 * density).ceil(),
    (48 * density).ceil(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return google.BitmapDescriptor.bytes(
    bytes!.buffer.asUint8List(),
    width: 42,
    height: 48,
    imagePixelRatio: density,
  );
}

class HauntedMapBadge extends StatelessWidget {
  const HauntedMapBadge({super.key});
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xE8100D0B),
        border: Border.all(color: const Color(0x55FF8A3D)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x77000000),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎃', style: TextStyle(fontSize: 15)),
          SizedBox(width: 7),
          Text(
            'Mapa assombrado',
            style: TextStyle(
              color: Color(0xFFF7E9DF),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: .22,
            ),
          ),
        ],
      ),
    ),
  );
}
