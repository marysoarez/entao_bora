import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class UserSettingsSection extends StatelessWidget {
  const UserSettingsSection({
    super.key,
    required this.locationSharingEnabled,
    required this.notificationsEnabled,
    required this.activatingNotifications,
    required this.onToggleLocation,
    required this.onToggleNotifications,
  });

  final bool locationSharingEnabled;
  final bool notificationsEnabled;
  final bool activatingNotifications;
  final VoidCallback onToggleLocation;
  final VoidCallback onToggleNotifications;

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações pessoais',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: DsColors.publicText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: DsSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: locationSharingEnabled,
            onChanged: (_) => onToggleLocation(),
            activeThumbColor: DsColors.success,
            title: const Text(
              'Localização',
              style: TextStyle(color: DsColors.publicText),
            ),
            subtitle: const Text(
              'Usada para check-ins e recomendações por perto.',
              style: TextStyle(color: DsColors.publicTextMuted),
            ),
          ),
          const Divider(color: Colors.white12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: notificationsEnabled,
            onChanged: activatingNotifications
                ? null
                : (_) => onToggleNotifications(),
            activeThumbColor: DsColors.success,
            secondary: activatingNotifications
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.notifications_active_outlined,
                    color: DsColors.accent,
                  ),
            title: const Text(
              'Notificações',
              style: TextStyle(color: DsColors.publicText),
            ),
            subtitle: const Text(
              'Receba avisos relacionados aos seus roles.',
              style: TextStyle(color: DsColors.publicTextMuted),
            ),
          ),
        ],
      ),
    );
  }
}
