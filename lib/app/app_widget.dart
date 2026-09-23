import 'package:entao_bora/core/app_theme.dart';
import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/notifications/data/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    Modular.get<AuthViewModel>().loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Modular.get<NotificationService>().requestPermissionOnStartup();
    });
  }

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
