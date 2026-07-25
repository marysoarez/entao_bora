import 'package:entao_bora/feature/events/presentation/viewmodels/events_bora_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/bora_button.dart';
import 'package:entao_bora/feature/events/presentation/widgets/checkin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../shared/enum/checkin_results.dart';

class EventActions extends StatelessWidget {
  const EventActions({
    super.key,
    required this.vm,
    required this.onLogin,
  });

  final EventActionsViewModel vm;
  final Future<void> Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final event = vm.event;

        return Row(
          children: [
            Expanded(
              flex: 6,
              child: BoraButton(
                active: event.isBora,
                count: event.boraCount,
                loading: vm.loading,
                onPressed: () async {
                  if (!vm.isLogged) {
                    await onLogin();
                    return;
                  }

                  await vm.toggleBora();
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 4,
              child: CheckinButton(
                checked: event.hasCheckedIn,
                count: event.checkinCount,
                loading: vm.loading,
                onPressed: () async {
                  if (!vm.isLogged) {
                    await onLogin();
                    return;
                  }

                  if (!vm.canCheckIn) return;

                  final result = await vm.checkIn();

                  if (!context.mounted) return;

                  switch (result) {
                    case CheckInResult.success:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("🤘 Check-in realizado!"),
                        ),
                      );
                      break;

                    case CheckInResult.tooFar:
                      _snack(
                        context,
                        "📍 Você precisa estar no local do evento.",
                      );
                      break;

                    case CheckInResult.eventNotStarted:
                      _snack(
                        context,
                        "⏰ O evento ainda não começou.",
                      );
                      break;

                    case CheckInResult.eventFinished:
                      _snack(
                        context,
                        "🎉 Este evento já terminou.",
                      );
                      break;

                    case CheckInResult.alreadyCheckedIn:
                      _snack(
                        context,
                        "✅ Você já fez check-in.",
                      );
                      break;

                    case CheckInResult.error:
                    case null:
                      _snack(
                        context,
                        vm.error ?? "Erro inesperado.",
                      );
                      break;
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}