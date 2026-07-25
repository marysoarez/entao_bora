import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

class PhotoStep extends StatefulWidget {
  const PhotoStep({super.key, required this.vm,
  });

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

    widget.vm.addPhoto(image);
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
              itemCount: widget.vm.photos.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                if (index == widget.vm.photos.length) {
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

                final photo = widget.vm.photos[index];

                return Stack(
                  children: [
                    if (kIsWeb)
                      Image.network(
                        photo.path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    else
                      Image.file(
                        File(photo.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            widget.vm.removePhoto(photo);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            if (widget.vm.photos.isEmpty) ...[
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
