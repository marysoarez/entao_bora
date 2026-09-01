import 'dart:io';
import 'package:entao_bora/shared/errors/image_exception.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

class PhotoStep extends StatefulWidget {
  const PhotoStep({super.key, required this.vm});

  final CreatePlaceViewModel vm;

  @override
  State<PhotoStep> createState() => _PhotoStepState();
}

class _PhotoStepState extends State<PhotoStep> {
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    try {
      await ImageHelper.fileToBase64(image);

      widget.vm.addPhoto(image);
    } on ImageTooLargeException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text("Fotos", style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 8),

            Text(
              "Adicione algumas fotos do estabelecimento.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  widget.vm.existingPhotos.length + widget.vm.photos.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final addButtonIndex =
                    widget.vm.existingPhotos.length + widget.vm.photos.length;

                if (index == addButtonIndex) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: pickImage,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.add_a_photo, size: 36),
                      ),
                    ),
                  );
                }

                if (index < widget.vm.existingPhotos.length) {
                  final photo = widget.vm.existingPhotos[index];

                  return _PhotoTile(
                    child: Image.memory(
                      ImageHelper.base64ToBytes(photo),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    onRemove: () {
                      widget.vm.removeExistingPhoto(photo);
                    },
                  );
                }

                final photo =
                    widget.vm.photos[index - widget.vm.existingPhotos.length];

                return _PhotoTile(
                  child: kIsWeb
                      ? Image.network(
                          photo.path,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.file(
                          File(photo.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                  onRemove: () {
                    widget.vm.removePhoto(photo);
                  },
                );
              },
            ),

            if (widget.vm.existingPhotos.isEmpty &&
                widget.vm.photos.isEmpty) ...[
              const SizedBox(height: 32),

              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "As fotos ajudam bastante os usuários a escolherem um lugar para ir.",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final Widget child;
  final VoidCallback onRemove;

  const _PhotoTile({required this.child, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
        Positioned(
          right: 4,
          top: 4,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.black54,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close, size: 16, color: Colors.white),
              onPressed: onRemove,
            ),
          ),
        ),
      ],
    );
  }
}
