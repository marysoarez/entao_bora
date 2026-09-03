import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class UserProfileSummary extends StatelessWidget {
  const UserProfileSummary({super.key, required this.user});

  final UserSummaryEntity user;

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perfil',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: DsColors.publicText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: DsSpacing.md),
          _InfoRow(icon: Icons.badge_outlined, label: 'Nome', value: user.name),
          _InfoRow(
            icon: Icons.mail_outline,
            label: 'E-mail',
            value: user.email ?? 'Nao informado',
          ),
          _InfoRow(
            icon: Icons.verified_user_outlined,
            label: 'Tipo de conta',
            value: user.isAnonymous ? 'Visitante' : 'Usuario comum',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DsColors.accent, size: 20),
          const SizedBox(width: DsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: DsColors.publicTextSubtle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: DsSpacing.xxs),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: DsColors.publicText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
