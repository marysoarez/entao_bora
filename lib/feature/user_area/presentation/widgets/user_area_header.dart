import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/places/presentation/widgets/user_avatar_widget.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class UserAreaHeader extends StatelessWidget {
  const UserAreaHeader({
    super.key,
    required this.user,
    required this.borasCount,
    required this.checkinsCount,
    required this.onEditProfile,
  });

  final UserSummaryEntity user;
  final int borasCount;
  final int checkinsCount;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      padding: const EdgeInsets.all(DsSpacing.xl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 640;

          final avatar = UserAvatar(
            photoUrl: user.photoUrl?.trim(),
            radius: compact ? 38 : 46,
          );

          final info = Column(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                user.name.isNotEmpty ? user.name : 'Usuario',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: compact ? TextAlign.center : TextAlign.start,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: DsColors.publicText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: DsSpacing.xs),
              Text(
                user.email ?? 'Conta sem e-mail cadastrado',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: compact ? TextAlign.center : TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DsColors.publicTextMuted,
                ),
              ),
              const SizedBox(height: DsSpacing.md),
              Wrap(
                spacing: DsSpacing.sm,
                runSpacing: DsSpacing.sm,
                alignment: compact ? WrapAlignment.center : WrapAlignment.start,
                children: [
                  _MetricChip(
                    icon: Icons.bolt,
                    label: 'Boras',
                    value: borasCount,
                    color: DsColors.warning,
                  ),
                  _MetricChip(
                    icon: Icons.how_to_reg,
                    label: 'Check-ins',
                    value: checkinsCount,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ],
          );

          final editButton = OutlinedButton.icon(
            onPressed: onEditProfile,
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            label: const Text(
              'Editar perfil',
              style: TextStyle(color: Colors.white),
            ),
          );

          if (compact) {
            return Column(
              children: [
                avatar,
                const SizedBox(height: DsSpacing.md),
                info,
                const SizedBox(height: DsSpacing.lg),
                SizedBox(width: double.infinity, child: editButton),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatar,
              const SizedBox(width: DsSpacing.lg),
              Expanded(child: info),
              const SizedBox(width: DsSpacing.lg),
              editButton,
            ],
          );
        },
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DsSpacing.md,
        vertical: DsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(DsRadius.pill),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: DsSpacing.xs),
          Text(
            '$value $label',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DsColors.publicText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
