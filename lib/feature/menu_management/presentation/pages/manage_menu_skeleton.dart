import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class ManageMenuSkeleton extends StatelessWidget {
  const ManageMenuSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DsAdminPage(
      maxWidth: DsSizes.maxFormWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonItem(width: 260, height: 34),
          SizedBox(height: DsSpacing.sm),
          _SkeletonItem(width: 420, height: 18),
          SizedBox(height: DsSpacing.xl),
          _ToolbarSkeleton(),
          SizedBox(height: DsSpacing.xl),
          _CategorySkeleton(),
          SizedBox(height: DsSpacing.md),
          _CategorySkeleton(),
        ],
      ),
    );
  }
}

class _ToolbarSkeleton extends StatelessWidget {
  const _ToolbarSkeleton();

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      padding: const EdgeInsets.all(DsSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 640;

          if (mobile) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonItem(width: double.infinity, height: 48),
                SizedBox(height: DsSpacing.sm),
                _SkeletonItem(width: double.infinity, height: 44),
                SizedBox(height: DsSpacing.sm),
                _SkeletonItem(width: double.infinity, height: 44),
              ],
            );
          }

          return const Row(
            children: [
              Expanded(child: _SkeletonItem(height: 48)),
              SizedBox(width: DsSpacing.md),
              _SkeletonItem(width: 150, height: 44),
              SizedBox(width: DsSpacing.sm),
              _SkeletonItem(width: 170, height: 44),
            ],
          );
        },
      ),
    );
  }
}

class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton();

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(DsSpacing.lg),
            child: Row(
              children: [
                Expanded(child: _SkeletonItem(height: 24)),
                SizedBox(width: DsSpacing.md),
                _SkeletonItem(
                  width: 42,
                  height: 42,
                  borderRadius: DsRadius.pill,
                ),
              ],
            ),
          ),
          Divider(height: 1),
          _MenuItemSkeleton(),
          Divider(height: 1),
          _MenuItemSkeleton(),
        ],
      ),
    );
  }
}

class _MenuItemSkeleton extends StatelessWidget {
  const _MenuItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(DsSpacing.lg),
      child: Row(
        children: [
          _SkeletonItem(width: 74, height: 74, borderRadius: DsRadius.xs),
          SizedBox(width: DsSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonItem(width: 220, height: 20),
                SizedBox(height: DsSpacing.xs),
                _SkeletonItem(width: double.infinity, height: 16),
                SizedBox(height: DsSpacing.xs),
                _SkeletonItem(width: 90, height: 18),
              ],
            ),
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
