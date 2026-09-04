import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class CreateEventSkeleton extends StatelessWidget {
  const CreateEventSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DsAdminPage(
      maxWidth: DsSizes.maxFormWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonItem(width: 170, height: 28),
          SizedBox(height: DsSpacing.lg),
          _SkeletonItem(width: double.infinity, height: 56),
          SizedBox(height: DsSpacing.md),
          _SkeletonItem(width: double.infinity, height: 120),
          SizedBox(height: DsSpacing.md),
          _SkeletonItem(width: double.infinity, height: 56),
          SizedBox(height: DsSpacing.xl),
          _SkeletonItem(
            width: double.infinity,
            height: 210,
            borderRadius: DsRadius.lg,
          ),
          SizedBox(height: DsSpacing.xxl),
          _SkeletonItem(width: 190, height: 24),
          SizedBox(height: DsSpacing.md),
          _SkeletonItem(width: double.infinity, height: 56),
          SizedBox(height: DsSpacing.md),
          _SkeletonItem(width: double.infinity, height: 56),
          SizedBox(height: DsSpacing.xxl),
          _SkeletonItem(
            width: double.infinity,
            height: 54,
            borderRadius: DsRadius.md,
          ),
        ],
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
    this.borderRadius = DsRadius.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: DsColors.publicText.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
