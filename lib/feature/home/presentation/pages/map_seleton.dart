import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/home_style.dart';

class MapSkeleton extends StatefulWidget {
  const MapSkeleton({super.key});
  @override
  State<MapSkeleton> createState() => _MapSkeletonState();
}

class _MapSkeletonState extends State<MapSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1350),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _animation.stop();
    } else {
      _animation.repeat();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Então Bora. Carregando mapa',
    liveRegion: true,
    child: ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, box) => ColoredBox(
          color: const Color(0xFF101217),
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _Streets())),
              for (final point in const [
                Offset(.15, .25),
                Offset(.75, .25),
                Offset(.3, .75),
                Offset(.85, .7),
              ])
                Positioned(
                  left: box.maxWidth * point.dx,
                  top: box.maxHeight * point.dy,
                  child: const HomeIcon(
                    HomeGlyph.pin,
                    size: 32,
                    color: Color(0x33FFFFFF),
                  ),
                ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 40,
                  ),
                  decoration: HomeStyle.box(
                    color: const Color(0x40000000),
                    border: const Color(0x0DFFFFFF),
                    radius: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Então Bora',
                        style: HomeStyle.type(
                          (MediaQuery.sizeOf(context).width * .04).clamp(
                            28,
                            36,
                          ),
                          weight: FontWeight.w800,
                          height: 1.2,
                          tracking: -.8,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Carregando',
                        style: HomeStyle.type(
                          15,
                          color: const Color(0xA6FFFFFF),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, _) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (i) {
                            final reduce = MediaQuery.disableAnimationsOf(
                              context,
                            );
                            final wave =
                                (1 -
                                    math.cos(
                                      (_animation.value - i / 3) * 2 * math.pi,
                                    )) /
                                2;
                            return Padding(
                              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                              child: Opacity(
                                opacity: reduce ? .65 : .25 + .75 * wave,
                                child: Transform.scale(
                                  scale: reduce ? 1 : 1 + .2 * wave,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Streets extends CustomPainter {
  const _Streets();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0FFFFFFF)
      ..strokeWidth = 12;
    for (final y in [.2, .5, .8]) {
      canvas.drawLine(
        Offset(0, size.height * y + 30),
        Offset(size.width, size.height * y - 30),
        paint,
      );
    }
    for (final x in [.25, .7]) {
      canvas.drawLine(
        Offset(size.width * x - 25, 0),
        Offset(size.width * x + 25, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_Streets oldDelegate) => false;
}
