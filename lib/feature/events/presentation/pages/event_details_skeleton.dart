import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class EventDetailsSkeleton extends StatelessWidget {
  const EventDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DsColors.publicBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroSkeleton(isDesktop: isDesktop),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : 16,
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),

                          // Título
                          _SkeletonItem(
                            width: 320,
                            height: 32,
                          ),

                          SizedBox(height: 12),

                          // Local
                          Row(
                            children: [
                              _CircleSkeleton(size: 20),
                              SizedBox(width: 10),
                              _SkeletonItem(
                                width: 220,
                                height: 16,
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Data
                          _InfoRowSkeleton(width: 180),

                          SizedBox(height: 14),

                          // Horário
                          _InfoRowSkeleton(width: 130),

                          SizedBox(height: 14),

                          // Endereço
                          _InfoRowSkeleton(),

                          SizedBox(height: 28),

                          // Botões
                          _ActionsSkeleton(),

                          SizedBox(height: 32),

                          // Sobre
                          _SkeletonItem(
                            width: 150,
                            height: 24,
                          ),

                          SizedBox(height: 16),

                          _SkeletonItem(
                            width: double.infinity,
                            height: 16,
                          ),

                          SizedBox(height: 8),

                          _SkeletonItem(
                            width: double.infinity,
                            height: 16,
                          ),

                          SizedBox(height: 8),

                          _SkeletonItem(
                            width: 280,
                            height: 16,
                          ),

                          SizedBox(height: 32),

                          // Gêneros / tags
                          _TagsSkeleton(),

                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  final bool isDesktop;

  const _HeroSkeleton({
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 420 : 300,
      child: Stack(
        children: [
          const Positioned.fill(
            child: _SkeletonItem(
              borderRadius: 0,
            ),
          ),

          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            left: 16,
            child: const _CircleSkeleton(size: 44),
          ),

          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            right: 16,
            child: const _CircleSkeleton(size: 44),
          ),
        ],
      ),
    );
  }
}

class _InfoRowSkeleton extends StatelessWidget {
  final double? width;

  const _InfoRowSkeleton({
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _CircleSkeleton(size: 20),
        const SizedBox(width: 10),
        _SkeletonItem(
          width: width ?? 260,
          height: 16,
        ),
      ],
    );
  }
}

class _ActionsSkeleton extends StatelessWidget {
  const _ActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _SkeletonItem(
            height: 50,
            borderRadius: 12,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SkeletonItem(
            height: 50,
            borderRadius: 12,
          ),
        ),
      ],
    );
  }
}

class _TagsSkeleton extends StatelessWidget {
  const _TagsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SkeletonItem(
          width: 80,
          height: 30,
          borderRadius: 20,
        ),
        _SkeletonItem(
          width: 110,
          height: 30,
          borderRadius: 20,
        ),
        _SkeletonItem(
          width: 90,
          height: 30,
          borderRadius: 20,
        ),
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