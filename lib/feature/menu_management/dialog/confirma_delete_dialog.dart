import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String itemName,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Excluir item'),
        content: Text(
          'Deseja excluir "$itemName" do cardapio?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}