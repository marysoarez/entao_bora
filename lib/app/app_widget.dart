import 'package:entao_bora/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Então Bora',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      routerConfig: Modular.routerConfig,
    );
  }
}