import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showDrawer;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.showDrawer = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final auth = Modular.get<AuthViewModel>();
    final canPop = Modular.to.canPop();

    return AppBar(
      elevation: 0,
      backgroundColor: DsColors.publicBackground,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,

      leading:
          leading ??
          (canPop
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: DsColors.publicText,
                  ),
                  onPressed: () => Modular.to.pop(),
                )
              : showDrawer
              ? Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: DsColors.publicText),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.home_outlined,
                    color: DsColors.publicText,
                  ),
                  onPressed: () => Modular.to.navigate('/home'),
                )),

      title: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(DsRadius.sm - 2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: DsColors.publicText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: .3,
              ),
            ),
          ),
        ],
      ),

      actions: [
        ...?actions,

        Observer(
          builder: (_) {
            return IconButton(
              tooltip: auth.isLogged ? 'Sair' : 'Entrar',
              icon: Icon(
                auth.isLogged ? Icons.logout : Icons.login,
                color: auth.isLogged ? DsColors.accent : DsColors.success,
              ),
              onPressed: () async {
                if (auth.isLogged) {
                  await auth.logout();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logout realizado com sucesso.'),
                    ),
                  );
                } else {
                  await auth.ensureLogged(context);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
