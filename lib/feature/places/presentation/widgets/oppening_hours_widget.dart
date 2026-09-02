import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:entao_bora/shared/enum/week_day_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class OpeningHoursStep extends StatelessWidget {
  const OpeningHoursStep({super.key, required this.vm});

  final CreatePlaceViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              "Horário de funcionamento",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              "Informe os dias e horários em que o estabelecimento funciona.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            ...Weekday.values.map((weekday) {
              final current = vm.openingHours.where(
                (e) => e.weekday == weekday,
              );

              final opening = current.isNotEmpty ? current.first : null;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          weekday.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Expanded(
                        child: opening == null
                            ? const Text("Fechado")
                            : Text(opening.formatted),
                      ),

                      TextButton(
                        onPressed: () async {
                          final open = await showTimePicker(
                            context: context,
                            initialTime:
                                opening?.opensAt ??
                                const TimeOfDay(hour: 18, minute: 0),
                          );

                          if (open == null) return;

                          if (!context.mounted) return;

                          final close = await showTimePicker(
                            context: context,
                            initialTime:
                                opening?.closesAt ??
                                const TimeOfDay(hour: 23, minute: 0),
                          );

                          if (close == null) return;

                          vm.setOpeningHours(
                            OpeningHours(
                              weekday: weekday,
                              opensAt: open,
                              closesAt: close,
                            ),
                          );
                        },
                        child: Text(opening == null ? "Adicionar" : "Editar"),
                      ),

                      if (opening != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            vm.removeOpeningHours(weekday);
                          },
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.schedule),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Você pode adicionar somente os dias em que o estabelecimento abre. Os demais serão considerados fechados.",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
