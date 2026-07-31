import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<AppAppBar> createState() => _AppAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppAppBarState extends State<AppAppBar> {
  final IAuthRepository _authRepository = Modular.get<IAuthRepository>();

  bool _logged = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authRepository.getCurrentUser();

    if (!mounted) return;

    setState(() {
      _logged = user != null;
    });
  }

  Future<void> _handleAuth(BuildContext context) async {
    if (_logged) {
      await _authRepository.signOut();

      if (!mounted) return;

      setState(() {
        _logged = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout realizado com sucesso.'),
        ),
      );
    } else {
      await LoginDialog.show(context);
      await _loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Modular.to.canPop();

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      centerTitle: widget.centerTitle,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,

      leading: widget.leading ??
          (canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Modular.to.pop(),
                )
              : widget.showDrawer
                  ? Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.home_outlined, color: Colors.white),
                      onPressed: () => Modular.to.navigate('/home'),
                    )),

      title: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: .3,
              ),
            ),
          ),
        ],
      ),

      actions: [
        ...?widget.actions,
        IconButton(
          tooltip: _logged ? 'Sair' : 'Entrar',
          icon: Icon(
            _logged ? Icons.logout : Icons.login,
            color: _logged ? Colors.red : Colors.green,
          ),
          onPressed: () => _handleAuth(context),
        ),
      ],
    );
  }
}