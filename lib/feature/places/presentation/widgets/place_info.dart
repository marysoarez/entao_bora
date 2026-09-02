import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PlaceInfoStep extends StatelessWidget {
  const PlaceInfoStep({super.key, required this.vm});

  final CreatePlaceViewModel vm;
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              "Informações",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              "Informe os dados do local que voce quer reivindicar.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),

            TextFormField(
              initialValue: vm.name,
              decoration: const InputDecoration(
                labelText: "Nome",
                hintText: "Ex.: Garage Pub",
                prefixIcon: Icon(Icons.store),
              ),
              textInputAction: TextInputAction.next,
              onChanged: vm.setName,
              validator: vm.validateName,
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<PlaceType>(
              initialValue: vm.type,
              decoration: const InputDecoration(
                labelText: "Tipo",
                prefixIcon: Icon(Icons.category),
              ),
              items: PlaceType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  vm.setType(value);
                }
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: vm.description,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Descrição",
                hintText: "Fale sobre o ambiente, estilos musicais, público...",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description),
              ),
              validator: vm.validateDescription,
              onChanged: vm.setDescription,
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: vm.instagram,
              decoration: const InputDecoration(
                labelText: "Instagram",
                hintText: "garagepubrj",
                prefixText: "@",
                prefixIcon: Icon(Icons.camera_alt),
              ),
              onChanged: vm.setInstagram,
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: vm.phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Telefone",
                hintText: "(21) 99999-9999",
                prefixIcon: Icon(Icons.phone),
              ),
              onChanged: vm.setPhone,
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: vm.website,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: "Website",
                hintText: "https://...",
                prefixIcon: Icon(Icons.language),
              ),
              onChanged: vm.setWebsite,
            ),

            const SizedBox(height: 40),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Voce precisa ser um parceiro para reivindicar um local. Na proxima etapa, pesquise pelo nome ou endereco como aparece no Google.",
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
