import 'package:flutter/material.dart';

class PartnerTransferEventDialog extends StatefulWidget {
  const PartnerTransferEventDialog({super.key});

  @override
  State<PartnerTransferEventDialog> createState() =>
      _PartnerTransferEventDialogState();
}

class _PartnerTransferEventDialogState
    extends State<PartnerTransferEventDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transferir evento'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'ID do usuario de destino',
          hintText: 'Cole o ID do usuario',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Transferir'),
        ),
      ],
    );
  }
}
