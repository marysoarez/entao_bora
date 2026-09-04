import 'package:flutter/material.dart';

class PartnerDashboardSkeleton extends StatelessWidget {
  const PartnerDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final metricWidth = width >= 900
                  ? (width - 48) / 4
                  : width >= 600
                  ? (width - 16) / 2
                  : width;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderSkeleton(),

                  const SizedBox(height: 24),

                  const _PlaceSelectorSkeleton(),

                  const SizedBox(height: 32),

                  const _SkeletonItem(width: 100, height: 26),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(
                      4,
                      (_) => SizedBox(
                        width: metricWidth,
                        child: const _MetricCardSkeleton(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  const _SkeletonItem(width: 180, height: 26),

                  const SizedBox(height: 16),

                  const _EventsSkeleton(),

                  const SizedBox(height: 36),

                  const _MenuSkeleton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        if (isMobile) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonItem(width: 220, height: 34),
              SizedBox(height: 8),
              _SkeletonItem(width: double.infinity, height: 18),
              SizedBox(height: 6),
              _SkeletonItem(width: 280, height: 18),
              SizedBox(height: 20),
              _SkeletonItem(
                width: double.infinity,
                height: 46,
                borderRadius: 12,
              ),
              SizedBox(height: 12),
              _SkeletonItem(
                width: double.infinity,
                height: 46,
                borderRadius: 12,
              ),
            ],
          );
        }

        return const Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 560,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonItem(width: 250, height: 34),
                  SizedBox(height: 8),
                  _SkeletonItem(width: 480, height: 18),
                ],
              ),
            ),
            _SkeletonItem(width: 145, height: 46, borderRadius: 12),
            _SkeletonItem(width: 135, height: 46, borderRadius: 12),
          ],
        );
      },
    );
  }
}

class _PlaceSelectorSkeleton extends StatelessWidget {
  const _PlaceSelectorSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _CircleSkeleton(size: 28),

                const SizedBox(width: 12),

                const Expanded(child: _SkeletonItem(height: 24)),

                const SizedBox(width: 16),

                const _CircleSkeleton(size: 36),
              ],
            ),

            const SizedBox(height: 14),

            const _SkeletonItem(width: 420, height: 16),
          ],
        ),
      ),
    );
  }
}

class _MetricCardSkeleton extends StatelessWidget {
  const _MetricCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _CircleSkeleton(size: 28),

            SizedBox(height: 18),

            _SkeletonItem(width: 100, height: 16),

            SizedBox(height: 8),

            _SkeletonItem(width: 60, height: 32),

            SizedBox(height: 8),

            _SkeletonItem(width: 130, height: 14),
          ],
        ),
      ),
    );
  }
}

class _EventsSkeleton extends StatelessWidget {
  const _EventsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          _EventTileSkeleton(),
          Divider(height: 1),
          _EventTileSkeleton(),
        ],
      ),
    );
  }
}

class _EventTileSkeleton extends StatelessWidget {
  const _EventTileSkeleton();

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
                _SkeletonItem(
                  width: double.infinity,
                  height: 180,
                  borderRadius: 8,
                ),

                SizedBox(height: 16),

                _SkeletonItem(width: 220, height: 22),

                SizedBox(height: 8),

                _SkeletonItem(width: double.infinity, height: 16),

                SizedBox(height: 6),

                _SkeletonItem(width: 260, height: 16),

                SizedBox(height: 14),

                _InfoChipsSkeleton(),

                SizedBox(height: 18),

                _DetailsSkeleton(),

                SizedBox(height: 18),

                _MetricsRowSkeleton(),
              ],
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonItem(width: 112, height: 112, borderRadius: 8),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonItem(width: 240, height: 22),

                        SizedBox(height: 8),

                        _SkeletonItem(width: double.infinity, height: 16),

                        SizedBox(height: 6),

                        _SkeletonItem(width: 320, height: 16),

                        SizedBox(height: 14),

                        _InfoChipsSkeleton(),
                      ],
                    ),
                  ),

                  SizedBox(width: 16),

                  Row(
                    children: [
                      _CircleSkeleton(size: 36),
                      SizedBox(width: 8),
                      _CircleSkeleton(size: 36),
                      SizedBox(width: 8),
                      _CircleSkeleton(size: 36),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 18),

              _DetailsSkeleton(),

              SizedBox(height: 18),

              _MetricsRowSkeleton(),
            ],
          );
        },
      ),
    );
  }
}

class _InfoChipsSkeleton extends StatelessWidget {
  const _InfoChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SkeletonItem(width: 100, height: 30, borderRadius: 20),
        _SkeletonItem(width: 120, height: 30, borderRadius: 20),
        _SkeletonItem(width: 90, height: 30, borderRadius: 20),
      ],
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        _SkeletonItem(width: 170, height: 18),
        _SkeletonItem(width: 260, height: 18),
        _SkeletonItem(width: 220, height: 18),
        _SkeletonItem(width: 130, height: 18),
        _SkeletonItem(width: 150, height: 18),
      ],
    );
  }
}

class _MetricsRowSkeleton extends StatelessWidget {
  const _MetricsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        _SkeletonItem(width: 55, height: 18),
        _SkeletonItem(width: 55, height: 18),
        _SkeletonItem(width: 55, height: 18),
        _SkeletonItem(width: 55, height: 18),
      ],
    );
  }
}

class _MenuSkeleton extends StatelessWidget {
  const _MenuSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _CircleSkeleton(size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SkeletonItem(width: 130, height: 24),
                            SizedBox(height: 8),
                            _SkeletonItem(width: 190, height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  _SkeletonItem(
                    width: double.infinity,
                    height: 46,
                    borderRadius: 12,
                  ),
                ],
              );
            }

            return const Row(
              children: [
                _CircleSkeleton(size: 28),

                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonItem(width: 130, height: 24),

                      SizedBox(height: 8),

                      _SkeletonItem(width: 190, height: 16),
                    ],
                  ),
                ),

                _SkeletonItem(width: 170, height: 46, borderRadius: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CircleSkeleton extends StatelessWidget {
  final double size;

  const _CircleSkeleton({required this.size});

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

  const _SkeletonItem({this.width, this.height, this.borderRadius = 8});

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
