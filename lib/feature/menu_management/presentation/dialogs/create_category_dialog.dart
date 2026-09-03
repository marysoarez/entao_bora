import 'package:flutter/material.dart';

Future<String?> showCreateCategoryDialog(BuildContext context) async {
  final controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Nova categoria'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome da categoria',
            hintText: 'Ex: Drinks, Porcoes, Sobremesas',
          ),
          onSubmitted: (value) {
            Navigator.of(context).pop(value.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text.trim());
            },
            child: const Text('Criar'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  return result;
}
