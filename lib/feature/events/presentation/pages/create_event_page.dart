import 'package:entao_bora/feature/events/presentation/pages/create_event_skeleton.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/create_event_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/adress_autocomplete_field.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_cover_step.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/ticket_type_enum.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final vm = Modular.get<CreateEventViewModel>();

  final _formKey = GlobalKey<FormState>();

  List<PlaceEntity> places = [];

  bool loadingPlaces = true;
  bool useRegisteredPlace = true;
  @override
  void initState() {
    super.initState();

    final place = Modular.args.data;
    if (place is PlaceEntity) {
      vm.setPlace(place);
    } else if (place is EventEntity) {
      vm.editEvent(place);
      useRegisteredPlace = place.placeId != null;
    }

    loadPlaces();
  }

  Future<void> loadPlaces() async {
    places = await vm.loadPlaces();

    final selectedPlace = vm.place;
    final editingEvent = vm.editingEvent;

    if (places.isNotEmpty) {
      if (editingEvent != null) {
        final index = places.indexWhere(
          (place) => place.id == editingEvent.placeId,
        );

        if (index >= 0) {
          vm.setPlace(places[index]);
          useRegisteredPlace = true;
        } else {
          useRegisteredPlace = false;
        }
      } else if (selectedPlace == null) {
        vm.setPlace(places.first);
      } else {
        final index = places.indexWhere(
          (place) => place.id == selectedPlace.id,
        );

        if (index >= 0) {
          vm.setPlace(places[index]);
        }
      }
    } else {
      useRegisteredPlace = false;
    }

    if (mounted) {
      setState(() {
        loadingPlaces = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DsColors.publicBackground,
      appBar: AppAppBar(
        title: vm.editingEvent == null ? "Criar Evento" : "Editar Evento",
      ),
      body: loadingPlaces
          ? const CreateEventSkeleton()
          : Observer(
              builder: (_) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Informações',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextFormField(
                          initialValue: vm.title,
                          decoration: const InputDecoration(
                            labelText: 'Nome do evento',
                          ),
                          validator: vm.validateTitle,
                          onChanged: vm.setTitle,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          initialValue: vm.description,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                          ),
                          validator: vm.validateDescription,
                          onChanged: vm.setDescription,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          initialValue: vm.instagram,
                          decoration: const InputDecoration(
                            labelText: 'Instagram',
                            hintText: '@garagegrindhouse',
                          ),
                          validator: vm.validateInstagram,
                          onChanged: vm.setInstagram,
                        ),

                        const SizedBox(height: 24),

                        EventCoverStep(vm: vm),

                        const SizedBox(height: 32),
                        const Text(
                          'Local do evento',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        RadioListTile<bool>(
                          value: true,
                          groupValue: useRegisteredPlace,
                          title: const Text('Meus Locais'),
                          onChanged: (value) {
                            setState(() {
                              useRegisteredPlace = true;
                            });
                          },
                        ),

                        RadioListTile<bool>(
                          value: false,
                          groupValue: useRegisteredPlace,
                          title: const Text('Outro endereço'),
                          onChanged: (value) {
                            setState(() {
                              useRegisteredPlace = false;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        if (useRegisteredPlace)
                          DropdownButtonFormField<PlaceEntity>(
                            initialValue: vm.place,
                            decoration: const InputDecoration(
                              labelText: 'Selecionar parceiro',
                            ),
                            items: places.map((place) {
                              return DropdownMenuItem(
                                value: place,
                                child: Text(place.name),
                              );
                            }).toList(),
                            onChanged: (place) {
                              if (place != null) {
                                vm.setPlace(place);
                              }
                            },
                          )
                        else
                          AddressAutocompleteField(
                            initialValue: vm.address,
                            search: vm.searchAddress,
                            onSelected: vm.setAddress,
                          ),
                        if (vm.address != null) ...[
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  initialValue: vm.address?.number,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: const InputDecoration(
                                    labelText: 'Número',
                                    hintText: 'Ex.: 123',
                                  ),
                                  onChanged: (value) {
                                    vm.setAddress(
                                      vm.address!.copyWith(
                                        number: value.trim(),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Complemento',
                                    hintText: 'Apto, bloco, referência...',
                                  ),
                                  onChanged: (value) {
                                    vm.setAddress(
                                      vm.address!.copyWith(
                                        complement: value.trim(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),
                        const Text(
                          'Data e horário',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.event),
                                label: Text(
                                  vm.startDate == null
                                      ? 'Data início'
                                      : '${vm.startDate!.day.toString().padLeft(2, '0')}/${vm.startDate!.month.toString().padLeft(2, '0')}/${vm.startDate!.year}',
                                ),
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: vm.startDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (date == null) return;

                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      vm.startDate ?? DateTime.now(),
                                    ),
                                  );

                                  if (time == null) return;

                                  vm.setStartDate(
                                    DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.event),
                                label: Text(
                                  vm.endDate == null
                                      ? 'Data término'
                                      : '${vm.endDate!.day.toString().padLeft(2, '0')}/${vm.endDate!.month.toString().padLeft(2, '0')}/${vm.endDate!.year}',
                                ),
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        vm.endDate ??
                                        vm.startDate ??
                                        DateTime.now(),
                                    firstDate: vm.startDate ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (date == null) return;

                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      vm.endDate ??
                                          vm.startDate ??
                                          DateTime.now(),
                                    ),
                                  );

                                  if (time == null) return;

                                  vm.setEndDate(
                                    DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Gêneros musicais',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: MusicGenre.values.map((genre) {
                            return FilterChip(
                              label: Text(genre.label),
                              selected: vm.musicGenres.contains(genre),
                              onSelected: (_) {
                                vm.toggleGenre(genre);
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Ingresso',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        RadioListTile<TicketType>(
                          value: TicketType.free,
                          groupValue: vm.ticket.type,
                          title: const Text('Gratuito'),
                          onChanged: (value) {
                            if (value != null) {
                              vm.setTicketType(value);
                            }
                          },
                        ),

                        RadioListTile<TicketType>(
                          value: TicketType.external,
                          groupValue: vm.ticket.type,
                          title: const Text('Venda externa'),
                          onChanged: (value) {
                            if (value != null) {
                              vm.setTicketType(value);
                            }
                          },
                        ),

                        if (vm.hasExternalTicket)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextFormField(
                              initialValue: vm.ticket.ticketUrl,
                              decoration: const InputDecoration(
                                labelText: 'Link para compra',
                                hintText: 'https://...',
                              ),
                              keyboardType: TextInputType.url,
                              onChanged: vm.setTicketUrl,
                            ),
                          ),

                        const SizedBox(height: 32),
                        Observer(
                          builder: (_) {
                            return SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: vm.loading
                                    ? null
                                    : () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        bool success;

                                        try {
                                          success = await vm.save();
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Erro: $e'),
                                              ),
                                            );
                                          }

                                          return;
                                        }

                                        if (!mounted) {
                                          return;
                                        }

                                        if (success) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                vm.editingEvent == null
                                                    ? 'Evento criado com sucesso!'
                                                    : 'Evento atualizado com sucesso!',
                                              ),
                                            ),
                                          );

                                          Navigator.of(context).pop(true);
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                vm.error ??
                                                    (vm.editingEvent == null
                                                        ? 'Erro ao criar evento.'
                                                        : 'Erro ao atualizar evento.'),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                child: vm.loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Text(
                                          vm.editingEvent == null
                                              ? 'PUBLICAR EVENTO'
                                              : 'SALVAR ALTERACOES',
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
