import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/user_area/presentation/viewmodels/user_area_viewmodel.dart';
import 'package:entao_bora/feature/user_area/presentation/widgets/user_activity_section.dart';
import 'package:entao_bora/feature/user_area/presentation/widgets/user_area_header.dart';
import 'package:entao_bora/feature/user_area/presentation/widgets/user_area_skeleton.dart';
import 'package:entao_bora/feature/user_area/presentation/widgets/user_events_section.dart';
import 'package:entao_bora/feature/user_area/presentation/widgets/user_profile_summary.dart';
import 'package:entao_bora/feature/user_area/presentation/widgets/user_settings_section.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/widgets/app_bar_widget.dart';
import 'package:entao_bora/shared/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UserAreaPage extends StatefulWidget {
  const UserAreaPage({super.key});

  @override
  State<UserAreaPage> createState() => _UserAreaPageState();
}

class _UserAreaPageState extends State<UserAreaPage> {
  late final UserAreaViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = Modular.get<UserAreaViewModel>();
    vm.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DsColors.publicBackground,
      appBar: const AppAppBar(title: 'Minha area', showDrawer: true),
      drawer: const AppDrawer(),
      body: Observer(
        builder: (_) {
          if (vm.loading) {
            return const UserAreaSkeleton();
          }

          final user = vm.user;

          if (user == null) {
            return _LoginRequired(onLogin: _login);
          }

          return RefreshIndicator(
            onRefresh: vm.load,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(DsSpacing.md),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: DsSizes.maxContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (vm.error != null) ...[
                            DsInlineError(message: vm.error!),
                            const SizedBox(height: DsSpacing.md),
                          ],
                          UserAreaHeader(
                            user: user,
                            borasCount: vm.boraEvents.length,
                            checkinsCount: vm.checkinEvents.length,
                            onEditProfile: _showEditProfileUnavailable,
                          ),
                          const SizedBox(height: DsSpacing.md),
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: UserProfileSummary(user: user)),
                                const SizedBox(width: DsSpacing.md),
                                Expanded(
                                  child: UserSettingsSection(
                                    locationEnabled: vm.locationEnabled,
                                    activatingNotifications:
                                        vm.activatingNotifications,
                                    onToggleLocation: _toggleLocation,
                                    onActivateNotifications:
                                        _activateNotifications,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            UserProfileSummary(user: user),
                            const SizedBox(height: DsSpacing.md),
                            UserSettingsSection(
                              locationEnabled: vm.locationEnabled,
                              activatingNotifications:
                                  vm.activatingNotifications,
                              onToggleLocation: _toggleLocation,
                              onActivateNotifications: _activateNotifications,
                            ),
                          ],
                          const SizedBox(height: DsSpacing.md),
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: UserEventsSection(
                                    title: 'Eventos que voce marcou Bora',
                                    emptyTitle: 'Nenhum Bora por enquanto',
                                    emptyMessage:
                                        'Explore o mapa e marque Bora nos eventos que combinam com voce.',
                                    icon: Icons.bolt,
                                    events: vm.boraEvents,
                                  ),
                                ),
                                const SizedBox(width: DsSpacing.md),
                                Expanded(
                                  child: UserEventsSection(
                                    title: 'Check-ins realizados',
                                    emptyTitle: 'Nenhum check-in ainda',
                                    emptyMessage:
                                        'Quando voce fizer check-in em um evento, ele aparece aqui.',
                                    icon: Icons.how_to_reg,
                                    events: vm.checkinEvents,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            UserEventsSection(
                              title: 'Eventos que voce marcou Bora',
                              emptyTitle: 'Nenhum Bora por enquanto',
                              emptyMessage:
                                  'Explore o mapa e marque Bora nos eventos que combinam com voce.',
                              icon: Icons.bolt,
                              events: vm.boraEvents,
                            ),
                            const SizedBox(height: DsSpacing.md),
                            UserEventsSection(
                              title: 'Check-ins realizados',
                              emptyTitle: 'Nenhum check-in ainda',
                              emptyMessage:
                                  'Quando voce fizer check-in em um evento, ele aparece aqui.',
                              icon: Icons.how_to_reg,
                              events: vm.checkinEvents,
                            ),
                          ],
                          const SizedBox(height: DsSpacing.md),
                          UserActivitySection(events: vm.recentActivity),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _login() async {
    await LoginDialog.show(context);
    await vm.load();
  }

  Future<void> _toggleLocation() async {
    if (vm.locationEnabled) {
      vm.disableLocation();
      return;
    }

    final enabled = await vm.enableLocation();
    if (!mounted || enabled) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(vm.error ?? 'Nao foi possivel obter sua localizacao.'),
      ),
    );
  }

  Future<void> _activateNotifications() async {
    final message = await vm.activateNotifications();
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showEditProfileUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edicao de perfil ainda nao esta disponivel.'),
      ),
    );
  }
}

class _LoginRequired extends StatelessWidget {
  const _LoginRequired({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DsSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: DsPublicCard(
            padding: const EdgeInsets.all(DsSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline,
                  color: DsColors.accent,
                  size: 42,
                ),
                const SizedBox(height: DsSpacing.md),
                Text(
                  'Entre para acessar sua area',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: DsColors.publicText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: DsSpacing.sm),
                const Text(
                  'Aqui ficam seus Boras, check-ins, perfil e preferencias pessoais.',
                  textAlign: TextAlign.center,
                  style: DsTextStyles.publicBody,
                ),
                const SizedBox(height: DsSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
