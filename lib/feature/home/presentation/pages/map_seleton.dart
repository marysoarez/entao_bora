import 'dart:async';

import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class MapSkeleton extends StatefulWidget {
  const MapSkeleton({super.key});

  @override
  State<MapSkeleton> createState() => _MapSkeletonState();
}

class _MapSkeletonState extends State<MapSkeleton> {
  int activeDot = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 450),
      (_) {
        if (!mounted) return;

        setState(() {
          activeDot = (activeDot + 1) % 3;
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: DsColors.publicBackground,
              ),
            ),

            const Positioned(
              left: -80,
              right: -80,
              top: 90,
              child: _StreetSkeleton(
                height: 16,
                rotation: -.08,
              ),
            ),

            const Positioned(
              left: -60,
              right: -100,
              top: 220,
              child: _StreetSkeleton(
                height: 12,
                rotation: .12,
              ),
            ),

            const Positioned(
              left: -100,
              right: -60,
              bottom: 120,
              child: _StreetSkeleton(
                height: 14,
                rotation: -.12,
              ),
            ),

            const Positioned(
              left: 90,
              top: -80,
              bottom: -100,
              child: _VerticalStreetSkeleton(
                width: 14,
                rotation: .08,
              ),
            ),

            Positioned(
              right: isDesktop ? 220 : 70,
              top: -100,
              bottom: -80,
              child: const _VerticalStreetSkeleton(
                width: 12,
                rotation: -.1,
              ),
            ),

            Positioned(
              left: isDesktop ? 180 : 55,
              top: 130,
              child: const _MapMarkerSkeleton(),
            ),

            Positioned(
              right: isDesktop ? 260 : 70,
              top: 260,
              child: const _MapMarkerSkeleton(),
            ),

            Positioned(
              left: isDesktop ? 380 : 140,
              bottom: 180,
              child: const _MapMarkerSkeleton(),
            ),

            if (isDesktop)
              const Positioned(
                right: 420,
                top: 150,
                child: _MapMarkerSkeleton(),
              ),

            if (isDesktop)
              const Positioned(
                left: 520,
                top: 360,
                child: _MapMarkerSkeleton(),
              ),

            Positioned(
              top: 16,
              left: 16,
              right: isDesktop ? 300 : 16,
              child: const _SearchSkeleton(),
            ),

            Positioned(
              right: 16,
              bottom: 90,
              child: Column(
                children: const [
                  _ControlSkeleton(),
                  SizedBox(height: 8),
                  _ControlSkeleton(),
                ],
              ),
            ),

            Center(
              child: _LoadingBrand(
                activeDot: activeDot,
                isDesktop: isDesktop,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LoadingBrand extends StatelessWidget {
  final int activeDot;
  final bool isDesktop;

  const _LoadingBrand({
    required this.activeDot,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 28,
        vertical: isDesktop ? 28 : 22,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: .05),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Então Bora',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 36 : 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Carregando',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .65),
              fontSize: isDesktop ? 15 : 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) {
                final isActive = activeDot == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 10 : 8,
                  height: isActive ? 10 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? DsColors.accent
                        : Colors.white.withValues(alpha: .25),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: DsColors.accent.withValues(alpha: .4),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _StreetSkeleton extends StatelessWidget {
  final double height;
  final double rotation;

  const _StreetSkeleton({
    required this.height,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _VerticalStreetSkeleton extends StatelessWidget {
  final double width;
  final double rotation;

  const _VerticalStreetSkeleton({
    required this.width,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _MapMarkerSkeleton extends StatelessWidget {
  const _MapMarkerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: DsColors.accent.withValues(alpha: .20),
        shape: BoxShape.circle,
        border: Border.all(
          color: DsColors.accent.withValues(alpha: .35),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: DsColors.accent.withValues(alpha: .45),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ControlSkeleton extends StatelessWidget {
  const _ControlSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}