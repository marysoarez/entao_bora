import 'package:entao_bora/feature/splash/presentation/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final vm = Modular.get<SplashViewModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ou Colors.white, conforme seu logo
      body: Center(
        child: Image.asset(
          'assets/images/entao_bora.jpg',
          width: 220,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}