import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AddressStep extends StatefulWidget {
  const AddressStep({super.key, required this.vm,
  });

  final CreatePlaceViewModel vm;

  @override
  State<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {

  final controller = TextEditingController();

  bool searching = false;

  List<AddressEntity> results = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> search() async {
    final query = controller.text.trim();

    if (query.isEmpty) return;

    setState(() => searching = true);

    results = await widget.vm.searchAddress(query);

    setState(() => searching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Endereço",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pesquise e selecione o endereço do estabelecimento.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => search(),
                          decoration: const InputDecoration(
                            hintText: "Rua, bairro ou estabelecimento",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: searching ? null : search,
                        child: const Text("Buscar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (searching)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (results.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Nenhum endereço pesquisado.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final address = results[index];

                    final selected =
                        widget.vm.address?.fullAddress == address.fullAddress;

                    return ListTile(
                      leading: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.location_on_outlined,
                      ),
                      title: Text(address.fullAddress),
                      selected: selected,
                      onTap: () {
                        widget.vm.setAddress(address);
                      },
                    );
                  },
                ),
              ),

            if (widget.vm.address != null)
              SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.place),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.vm.address!.fullAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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