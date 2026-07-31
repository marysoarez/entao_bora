import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart' show AuthViewModel;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  final auth = Modular.get<AuthViewModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await auth.loadUser();

      Modular.to.navigate(
        '/home',
        arguments: {
          'showLogin': !auth.isLogged,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/entao_bora.jpg',
          width: 220,
        ),
      ),
    );
  }
}