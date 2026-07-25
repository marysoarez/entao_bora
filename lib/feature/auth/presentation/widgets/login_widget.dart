import 'package:entao_bora/feature/auth/presentation/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (_) => const LoginDialog(),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Modular.get<LoginViewModel>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Observer(
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 34,
                  child: Icon(Icons.music_note, size: 34),
                ),

                const SizedBox(height: 20),

                Text(
                  "Então Bora",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 12),

                Text(
                  "Entre para marcar presença, fazer check-in e criar eventos.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Você poderá:"),
                ),

                const SizedBox(height: 12),

                const _Item("🤘 Marcar presença"),
                const _Item("📍 Fazer check-in"),
                const _Item("🎸 Criar eventos"),
                const _Item("🏠 Cadastrar locais"),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: vm.loading
                        ? null
                        : () async {
                            try {
                              final success = await vm.loginWithGoogle();

                              if (!context.mounted) return;

                              if (success) {
                                Navigator.of(context).pop(true);
                              }
                            } catch (e) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao entrar: $e')),
                              );
                            }
                          },
                    icon: vm.loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: const Text("Entrar com Google"),
                  ),
                ),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Agora não"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
