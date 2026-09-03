import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class ManagePlacesSkeleton extends StatelessWidget {
  const ManagePlacesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DsAdminPage(
      maxWidth: DsSizes.maxFormWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSkeleton(isMobile: isMobile),

              const SizedBox(height: 24),

              Card(
                child: Column(
                  children: const [
                    _PlaceTileSkeleton(),
                    Divider(height: 1),
                    _PlaceTileSkeleton(),
                    Divider(height: 1),
                    _PlaceTileSkeleton(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  final bool isMobile;

  const _HeaderSkeleton({
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonItem(
            width: 230,
            height: 32,
          ),

          SizedBox(height: 8),

          _SkeletonItem(
            width: double.infinity,
            height: 16,
          ),

          SizedBox(height: 6),

          _SkeletonItem(
            width: 250,
            height: 16,
          ),

          SizedBox(height: 20),

          _SkeletonItem(
            width: double.infinity,
            height: 46,
            borderRadius: 12,
          ),
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonItem(
                width: 260,
                height: 32,
              ),

              SizedBox(height: 8),

              _SkeletonItem(
                width: 420,
                height: 16,
              ),
            ],
          ),
        ),

        SizedBox(width: 24),

        _SkeletonItem(
          width: 145,
          height: 46,
          borderRadius: 12,
        ),
      ],
    );
  }
}

class _PlaceTileSkeleton extends StatelessWidget {
  const _PlaceTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;

          if (isMobile) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonItem(
                      width: 72,
                      height: 72,
                      borderRadius: 10,
                    ),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonItem(
                            width: 180,
                            height: 20,
                          ),

                          SizedBox(height: 8),

                          _SkeletonItem(
                            width: double.infinity,
                            height: 15,
                          ),

                          SizedBox(height: 6),

                          _SkeletonItem(
                            width: 190,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                _InfoSkeleton(),

                SizedBox(height: 18),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SkeletonItem(
                      width: 85,
                      height: 38,
                      borderRadius: 10,
                    ),
                    _SkeletonItem(
                      width: 100,
                      height: 38,
                      borderRadius: 10,
                    ),
                    _SkeletonItem(
                      width: 85,
                      height: 38,
                      borderRadius: 10,
                    ),
                    _SkeletonItem(
                      width: 80,
                      height: 38,
                      borderRadius: 10,
                    ),
                  ],
                ),
              ],
            );
          }

          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonItem(
                width: 88,
                height: 88,
                borderRadius: 10,
              ),

              SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonItem(
                      width: 220,
                      height: 22,
                    ),

                    SizedBox(height: 8),

                    _SkeletonItem(
                      width: 420,
                      height: 16,
                    ),

                    SizedBox(height: 12),

                    _InfoSkeleton(),
                  ],
                ),
              ),

              SizedBox(width: 20),

              _ActionsSkeleton(),
            ],
          );
        },
      ),
    );
  }
}

class _InfoSkeleton extends StatelessWidget {
  const _InfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _SkeletonItem(
          width: 90,
          height: 28,
          borderRadius: 20,
        ),

        _SkeletonItem(
          width: 110,
          height: 28,
          borderRadius: 20,
        ),

        _SkeletonItem(
          width: 80,
          height: 28,
          borderRadius: 20,
        ),
      ],
    );
  }
}

class _ActionsSkeleton extends StatelessWidget {
  const _ActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _CircleSkeleton(size: 38),
        _CircleSkeleton(size: 38),
        _CircleSkeleton(size: 38),
        _CircleSkeleton(size: 38),
      ],
    );
  }
}

class _CircleSkeleton extends StatelessWidget {
  final double size;

  const _CircleSkeleton({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const _SkeletonItem({
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}