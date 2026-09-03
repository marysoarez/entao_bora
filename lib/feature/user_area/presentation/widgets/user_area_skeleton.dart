import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class UserAreaSkeleton extends StatelessWidget {
  const UserAreaSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 840;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(DsSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: DsSizes.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SkeletonCard(height: 156),
                  const SizedBox(height: DsSpacing.md),
                  if (twoColumns)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _SkeletonCard(height: 220)),
                        SizedBox(width: DsSpacing.md),
                        Expanded(child: _SkeletonCard(height: 220)),
                      ],
                    )
                  else ...[
                    const _SkeletonCard(height: 220),
                    const SizedBox(height: DsSpacing.md),
                    const _SkeletonCard(height: 220),
                  ],
                  const SizedBox(height: DsSpacing.md),
                  const _SkeletonCard(height: 190),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(DsSpacing.lg),
      decoration: BoxDecoration(
        color: DsColors.publicSurface,
        borderRadius: BorderRadius.circular(DsRadius.lg),
        border: Border.all(color: DsColors.accent.withValues(alpha: .10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(width: 180, height: 22),
          const SizedBox(height: DsSpacing.lg),
          _bar(width: double.infinity, height: 48),
          const SizedBox(height: DsSpacing.sm),
          _bar(width: double.infinity, height: 48),
          const Spacer(),
          _bar(width: 120, height: 18),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: DsColors.publicText.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(DsRadius.xs),
      ),
    );
  }
}
