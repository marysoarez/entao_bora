import 'dart:io';

import 'package:entao_bora/feature/events/presentation/viewmodels/create_event_viewmodel.dart';
import 'package:entao_bora/shared/errors/image_exception.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

class EventCoverStep extends StatefulWidget {
  const EventCoverStep({super.key, required this.vm});

  final CreateEventViewModel vm;

  @override
  State<EventCoverStep> createState() => _EventCoverStepState();
}

class _EventCoverStepState extends State<EventCoverStep> {
  final picker = ImagePicker();

  bool _isProcessing = false;

  Future<void> pickImage() async {
    if (_isProcessing) return;

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    if (!mounted) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Valida e processa a imagem antes de exibi-la.
      await ImageHelper.fileToBase64(image);

      if (!mounted) return;

      widget.vm.setCoverPhoto(image);
    } on ImageTooLargeException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível processar a imagem.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Imagem de capa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text('Escolha uma imagem que represente o evento.'),

            const SizedBox(height: 16),

            InkWell(
              onTap: _isProcessing ? null : pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: _isProcessing
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                            SizedBox(height: 16),
                            Text('Processando imagem...'),
                          ],
                        ),
                      )
                    : widget.vm.coverPhoto == null
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 48),
                            SizedBox(height: 8),
                            Text('Selecionar imagem'),
                          ],
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: kIsWeb
                                ? Image.network(
                                    widget.vm.coverPhoto!.path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(widget.vm.coverPhoto!.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),

                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: _isProcessing
                                    ? null
                                    : widget.vm.removeCoverPhoto,
                              ),
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
