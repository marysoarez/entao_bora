import 'package:entao_bora/app/app_module.dart';
import 'package:entao_bora/app/app_widget.dart';
import 'package:entao_bora/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initializeDateFormatting('pt_BR');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
