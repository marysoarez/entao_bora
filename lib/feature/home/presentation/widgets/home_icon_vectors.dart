// Lucide React 1.31.0 vectors, ISC license: docs/licenses/lucide.txt.
part of 'home_style.dart';

void _paintHomeGlyph(Canvas canvas, Paint paint, HomeGlyph glyph) {
  switch (glyph) {
    case HomeGlyph.chevron:
      canvas.drawPath(
        Path()
          ..moveTo(6, 9)
          ..lineTo(12, 15)
          ..lineTo(18, 9),
        paint,
      );
    case HomeGlyph.compass:
      canvas.drawCircle(Offset(12.0, 12.0), 10.0, paint);
      canvas.drawPath(
        Path()
          ..relativeMoveTo(16.24, 7.76)
          ..relativeLineTo(-1.804, 5.411)
          ..relativeArcToPoint(
            Offset(-1.265, 1.265),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..lineTo(7.76, 16.24)
          ..relativeLineTo(1.804, -5.411)
          ..relativeArcToPoint(
            Offset(1.265, -1.265),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..close(),
        paint,
      );
    case HomeGlyph.user:
      canvas.drawCircle(Offset(12.0, 8.0), 5.0, paint);
      canvas.drawPath(
        Path()
          ..moveTo(20.0, 21.0)
          ..relativeArcToPoint(
            Offset(-16.0, 0.0),
            radius: Radius.elliptical(8.0, 8.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          ),
        paint,
      );
    case HomeGlyph.login:
      canvas.drawPath(
        Path()
          ..relativeMoveTo(10.0, 17.0)
          ..relativeLineTo(5.0, -5.0)
          ..relativeLineTo(-5.0, -5.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(15.0, 12.0)
          ..lineTo(3.0, 12.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(15.0, 3.0)
          ..relativeLineTo(4.0, 0.0)
          ..relativeArcToPoint(
            Offset(2.0, 2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeLineTo(0.0, 14.0)
          ..relativeArcToPoint(
            Offset(-2.0, 2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeLineTo(-4.0, 0.0),
        paint,
      );
    case HomeGlyph.logout:
      canvas.drawPath(
        Path()
          ..relativeMoveTo(16.0, 17.0)
          ..relativeLineTo(5.0, -5.0)
          ..relativeLineTo(-5.0, -5.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(21.0, 12.0)
          ..lineTo(9.0, 12.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(9.0, 21.0)
          ..lineTo(5.0, 21.0)
          ..relativeArcToPoint(
            Offset(-2.0, -2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..lineTo(3.0, 5.0)
          ..relativeArcToPoint(
            Offset(2.0, -2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeLineTo(4.0, 0.0),
        paint,
      );
    case HomeGlyph.pin:
      canvas.drawPath(
        Path()
          ..moveTo(20.0, 10.0)
          ..relativeCubicTo(0.0, 4.993, -5.539, 10.193, -7.399, 11.799)
          ..relativeArcToPoint(
            Offset(-1.202, 0.0),
            radius: Radius.elliptical(1.0, 1.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..cubicTo(9.539, 20.193, 4.0, 14.993, 4.0, 10.0)
          ..relativeArcToPoint(
            Offset(16.0, 0.0),
            radius: Radius.elliptical(8.0, 8.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          ),
        paint,
      );
      canvas.drawCircle(Offset(12.0, 10.0), 3.0, paint);
    case HomeGlyph.search:
      canvas.drawPath(
        Path()
          ..relativeMoveTo(21.0, 21.0)
          ..relativeLineTo(-4.34, -4.34),
        paint,
      );
      canvas.drawCircle(Offset(11.0, 11.0), 8.0, paint);
    case HomeGlyph.sliders:
      canvas.drawPath(
        Path()
          ..moveTo(10.0, 5.0)
          ..lineTo(3.0, 5.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(12.0, 19.0)
          ..lineTo(3.0, 19.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(14.0, 3.0)
          ..relativeLineTo(0.0, 4.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(16.0, 17.0)
          ..relativeLineTo(0.0, 4.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(21.0, 12.0)
          ..relativeLineTo(-9.0, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(21.0, 19.0)
          ..relativeLineTo(-5.0, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(21.0, 5.0)
          ..relativeLineTo(-7.0, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 10.0)
          ..relativeLineTo(0.0, 4.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 12.0)
          ..lineTo(3.0, 12.0),
        paint,
      );
    case HomeGlyph.music:
      canvas.drawCircle(Offset(8.0, 18.0), 4.0, paint);
      canvas.drawPath(
        Path()
          ..moveTo(12.0, 18.0)
          ..lineTo(12.0, 2.0)
          ..relativeLineTo(7.0, 4.0),
        paint,
      );
    case HomeGlyph.list:
      canvas.drawPath(
        Path()
          ..moveTo(3.0, 5.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(3.0, 12.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(3.0, 19.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 5.0)
          ..relativeLineTo(13.0, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 12.0)
          ..relativeLineTo(13.0, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 19.0)
          ..relativeLineTo(13.0, 0.0),
        paint,
      );
    case HomeGlyph.arrow:
      canvas.drawPath(
        Path()
          ..moveTo(7.0, 7.0)
          ..relativeLineTo(10.0, 0.0)
          ..relativeLineTo(0.0, 10.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(7.0, 17.0)
          ..lineTo(17.0, 7.0),
        paint,
      );
    case HomeGlyph.calendar:
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 2.0)
          ..relativeLineTo(0.0, 3.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(16.0, 2.0)
          ..relativeLineTo(0.0, 3.0),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(3.0, 3.0, 18.0, 18.0),
          Radius.circular(2.0),
        ),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(3.0, 9.0)
          ..relativeLineTo(18.0, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 13.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(12.0, 13.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(16.0, 13.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(8.0, 17.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(12.0, 17.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(16.0, 17.0)
          ..relativeLineTo(0.01, 0.0),
        paint,
      );
    case HomeGlyph.store:
      canvas.drawPath(
        Path()
          ..moveTo(15.0, 21.0)
          ..relativeLineTo(0.0, -5.0)
          ..relativeArcToPoint(
            Offset(-1.0, -1.0),
            radius: Radius.elliptical(1.0, 1.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeLineTo(-4.0, 0.0)
          ..relativeArcToPoint(
            Offset(-1.0, 1.0),
            radius: Radius.elliptical(1.0, 1.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeLineTo(0.0, 5.0),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(17.774, 10.31)
          ..relativeArcToPoint(
            Offset(-1.549, 0.0),
            radius: Radius.elliptical(1.12, 1.12),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeArcToPoint(
            Offset(-3.451, 0.0),
            radius: Radius.elliptical(2.5, 2.5),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeArcToPoint(
            Offset(-1.548, 0.0),
            radius: Radius.elliptical(1.12, 1.12),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeArcToPoint(
            Offset(-3.452, 0.0),
            radius: Radius.elliptical(2.5, 2.5),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeArcToPoint(
            Offset(-1.549, 0.0),
            radius: Radius.elliptical(1.12, 1.12),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeArcToPoint(
            Offset(-3.77, -3.248),
            radius: Radius.elliptical(2.5, 2.5),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeLineTo(2.889, -4.184)
          ..arcToPoint(
            Offset(7.0, 2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeLineTo(10.0, 0.0)
          ..relativeArcToPoint(
            Offset(1.653, 0.873),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          )
          ..relativeLineTo(2.895, 4.192)
          ..relativeArcToPoint(
            Offset(-3.774, 3.244),
            radius: Radius.elliptical(2.5, 2.5),
            rotation: 0.0,
            largeArc: false,
            clockwise: true,
          ),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(4.0, 10.95)
          ..lineTo(4.0, 19.0)
          ..relativeArcToPoint(
            Offset(2.0, 2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeLineTo(12.0, 0.0)
          ..relativeArcToPoint(
            Offset(2.0, -2.0),
            radius: Radius.elliptical(2.0, 2.0),
            rotation: 0.0,
            largeArc: false,
            clockwise: false,
          )
          ..relativeLineTo(0.0, -8.05),
        paint,
      );
  }
}
