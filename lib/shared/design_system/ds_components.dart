import 'package:entao_bora/shared/design_system/ds_tokens.dart';
import 'package:flutter/material.dart';

class DsAdminPage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const DsAdminPage({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DsSpacing.xl),
    this.maxWidth = DsSizes.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class DsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const DsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DsColors.publicSurface,
      child: Padding(
        padding: const EdgeInsets.all(DsSpacing.xxl - DsSpacing.xxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 34, color: DsColors.primary),
            const SizedBox(height: DsSpacing.lg - 2),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: DsColors.publicText,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DsSpacing.xs),
            Text(message, style: DsTextStyles.publicBody),
            const SizedBox(height: DsSpacing.lg),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class DsInlineError extends StatelessWidget {
  final String message;

  const DsInlineError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DsSpacing.md - 2),
      decoration: BoxDecoration(
        color: DsColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(DsRadius.xs),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: DsColors.accent),
      ),
    );
  }
}

class DsPublicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DsPublicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DsSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: DsColors.publicSurface,
        borderRadius: BorderRadius.circular(DsRadius.lg),
        border: Border.all(color: DsColors.accent.withValues(alpha: .15)),
      ),
      child: child,
    );
  }
}

class DsHeroIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  const DsHeroIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: DsColors.publicOverlay,
      borderRadius: BorderRadius.circular(DsRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(DsRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(DsSpacing.sm - 2),
          child: Icon(icon, color: DsColors.publicText, size: 22),
        ),
      ),
    );

    if (tooltip == null) return button;

    return Tooltip(message: tooltip!, child: button);
  }
}

class DsPublicHero extends StatelessWidget {
  final Widget image;
  final String title;
  final double height;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final double titleFontSize;
  final bool uppercaseTitle;

  const DsPublicHero({
    super.key,
    required this.image,
    required this.title,
    this.height = DsSizes.eventHeroHeight,
    this.onBack,
    this.onShare,
    this.titleFontSize = 30,
    this.uppercaseTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = uppercaseTitle ? title.toUpperCase() : title;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    DsColors.publicBackground.withValues(alpha: .15),
                    DsColors.publicBackground.withValues(alpha: .35),
                    DsColors.publicBackground.withValues(alpha: .92),
                  ],
                  stops: const [.15, .55, 1],
                ),
              ),
            ),
          ),
          if (onBack != null)
            Positioned(
              top: DsSpacing.md,
              left: DsSpacing.md,
              child: DsHeroIconButton(
                icon: Icons.arrow_back,
                tooltip: 'Voltar',
                onTap: onBack,
              ),
            ),
          if (onShare != null)
            Positioned(
              top: DsSpacing.md,
              right: DsSpacing.md,
              child: DsHeroIconButton(
                icon: Icons.share_outlined,
                tooltip: 'Compartilhar',
                onTap: onShare,
              ),
            ),
          Positioned(
            left: DsSpacing.lg,
            right: DsSpacing.lg,
            bottom: DsSpacing.lg + 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: DsColors.publicText,
                    fontSize: titleFontSize,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: DsSpacing.sm - 2),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: DsColors.accent,
                    borderRadius: BorderRadius.circular(DsRadius.sm - 2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DsActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const DsActionChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = DsColors.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DsColors.publicText.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(DsRadius.xxl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DsRadius.xxl),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DsSpacing.md - 2,
            vertical: DsSpacing.sm - 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: DsSpacing.xs),
              Text(
                label,
                style: const TextStyle(
                  color: DsColors.publicText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
