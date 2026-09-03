import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class UserSettingsSection extends StatelessWidget {
  const UserSettingsSection({
    super.key,
    required this.locationEnabled,
    required this.activatingNotifications,
    required this.onToggleLocation,
    required this.onActivateNotifications,
  });

  final bool locationEnabled;
  final bool activatingNotifications;
  final VoidCallback onToggleLocation;
  final VoidCallback onActivateNotifications;

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuracoes pessoais',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: DsColors.publicText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: DsSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: locationEnabled,
            onChanged: (_) => onToggleLocation(),
            activeThumbColor: DsColors.success,
            title: const Text(
              'Localizacao',
              style: TextStyle(color: DsColors.publicText),
            ),
            subtitle: const Text(
              'Usada para check-ins e recomendacoes por perto.',
              style: TextStyle(color: DsColors.publicTextMuted),
            ),
          ),
          const Divider(color: Colors.white12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: activatingNotifications
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
              'Notificacoes',
              style: TextStyle(color: DsColors.publicText),
            ),
            subtitle: const Text(
              'Receba avisos relacionados aos seus roles.',
              style: TextStyle(color: DsColors.publicTextMuted),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: DsColors.publicTextSubtle,
            ),
            onTap: activatingNotifications ? null : onActivateNotifications,
          ),
        ],
      ),
    );
  }
}
