import 'package:entao_bora/feature/events/presentation/widgets/adress_autocomplete_field.dart';
import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddressStep extends StatefulWidget {
  const AddressStep({super.key, required this.vm});

  final CreatePlaceViewModel vm;

  @override
  State<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Endereço",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              Text(
                "Pesquise pelo nome do local ou endereco como aparece no Google.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              AddressAutocompleteField(
                initialValue: widget.vm.address,
                search: widget.vm.searchAddress,
                onSelected: widget.vm.setAddress,
              ),

              if (widget.vm.address != null) ...[
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: widget.vm.address?.number,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(labelText: 'Número'),
                        onChanged: (value) {
                          widget.vm.setAddress(
                            widget.vm.address!.copyWith(number: value),
                          );
                        },
                        onFieldSubmitted: (_) {
                          widget.vm.resolveAddressLocation();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: widget.vm.address?.complement,
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                        ),
                        onChanged: (value) {
                          widget.vm.setAddress(
                            widget.vm.address!.copyWith(complement: value),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.place),
                      const SizedBox(width: 12),
                      Expanded(child: Text(widget.vm.address!.fullAddress)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
