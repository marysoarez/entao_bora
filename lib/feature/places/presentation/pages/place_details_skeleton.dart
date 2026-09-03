import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class PlaceDetailsSkeleton extends StatelessWidget {
  const PlaceDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DsColors.publicBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _HeroSkeleton(isDesktop: isDesktop),

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Nome do estabelecimento
                        const _SkeletonItem(
                          width: 280,
                          height: 30,
                        ),

                        const SizedBox(height: 12),

                        // Descrição
                        const _SkeletonItem(
                          width: double.infinity,
                          height: 16,
                        ),

                        const SizedBox(height: 8),

                        const _SkeletonItem(
                          width: 320,
                          height: 16,
                        ),

                        const SizedBox(height: 20),

                        // Endereço / infos
                        const _InfoSkeleton(),

                        const SizedBox(height: 24),

                        // Botões de ação
                        _ActionsSkeleton(isDesktop: isDesktop),

                        const SizedBox(height: 24),

                        // Gêneros musicais
                        const _GenresSkeleton(),

                        const SizedBox(height: 32),

                        // Eventos
                        const _SkeletonItem(
                          width: 180,
                          height: 24,
                        ),

                        const SizedBox(height: 16),

                        _EventsSkeleton(isDesktop: isDesktop),

                        const SizedBox(height: 32),

                        // Owner
                        const _OwnerSkeleton(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
      height: isDesktop ? 420 : 280,
      width: double.infinity,
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

class _InfoSkeleton extends StatelessWidget {
  const _InfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _CircleSkeleton(size: 20),
            SizedBox(width: 10),
            Expanded(
              child: _SkeletonItem(
                height: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _CircleSkeleton(size: 20),
            SizedBox(width: 10),
            _SkeletonItem(
              width: 180,
              height: 16,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionsSkeleton extends StatelessWidget {
  final bool isDesktop;

  const _ActionsSkeleton({
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return const Row(
        children: [
          Expanded(
            child: _SkeletonItem(height: 52),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _SkeletonItem(height: 52),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _SkeletonItem(height: 52),
          ),
        ],
      );
    }

    return const Row(
      children: [
        Expanded(
          child: _SkeletonItem(height: 52),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _SkeletonItem(height: 52),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _SkeletonItem(height: 52),
        ),
      ],
    );
  }
}

class _GenresSkeleton extends StatelessWidget {
  const _GenresSkeleton();

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
          width: 95,
          height: 30,
          borderRadius: 20,
        ),
        _SkeletonItem(
          width: 70,
          height: 30,
          borderRadius: 20,
        ),
      ],
    );
  }
}

class _EventsSkeleton extends StatelessWidget {
  final bool isDesktop;

  const _EventsSkeleton({
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return const Row(
        children: [
          Expanded(child: _EventCardSkeleton()),
          SizedBox(width: 16),
          Expanded(child: _EventCardSkeleton()),
          SizedBox(width: 16),
          Expanded(child: _EventCardSkeleton()),
        ],
      );
    }

    return const SizedBox(
      height: 230,
      child: Row(
        children: [
          Expanded(child: _EventCardSkeleton()),
          SizedBox(width: 12),
          Expanded(child: _EventCardSkeleton()),
        ],
      ),
    );
  }
}

class _EventCardSkeleton extends StatelessWidget {
  const _EventCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonItem(
          width: double.infinity,
          height: 150,
          borderRadius: 14,
        ),
        SizedBox(height: 10),
        _SkeletonItem(
          width: 140,
          height: 18,
        ),
        SizedBox(height: 8),
        _SkeletonItem(
          width: 100,
          height: 14,
        ),
      ],
    );
  }
}

class _OwnerSkeleton extends StatelessWidget {
  const _OwnerSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonItem(
          width: 170,
          height: 24,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            _CircleSkeleton(size: 48),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonItem(
                    width: 160,
                    height: 18,
                  ),
                  SizedBox(height: 8),
                  _SkeletonItem(
                    width: 110,
                    height: 14,
                  ),
                ],
              ),
            ),
          ],
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