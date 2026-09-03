import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/errors/image_exception.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MenuItemDialog extends StatefulWidget {
  final MenuItemEntity? item;
  final List<String> categories;
  final String? initialCategory;

  const MenuItemDialog({
    super.key,
    this.item,
    required this.categories,
    this.initialCategory,
  });

  @override
  State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  final _picker = ImagePicker();

  String _photo = '';
  String? _selectedCategory;

  bool _processingPhoto = false;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _selectedCategory = item?.category.trim().isNotEmpty == true
        ? item!.category
        : widget.initialCategory ?? widget.categories.first;

    if (item == null) return;

    _titleController.text = item.title;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toStringAsFixed(2).replaceAll('.', ',');

    _photo = item.photo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();

    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_processingPhoto) return;

    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _processingPhoto = true;
    });

    try {
      final base64 = await ImageHelper.fileToBase64(image);

      if (!mounted) return;

      setState(() {
        _photo = base64;
      });
    } on ImageTooLargeException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel processar a imagem.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _processingPhoto = false;
        });
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final customCategory = _categoryController.text.trim();

    final category = customCategory.isNotEmpty
        ? customCategory
        : _selectedCategory?.trim() ?? 'Geral';

    Navigator.of(context).pop(
      MenuItemEntity(
        id: widget.item?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _parsePrice(_priceController.text),
        photo: _photo,
        category: category,
      ),
    );
  }

  double _parsePrice(String value) {
    final normalized = value.contains(',')
        ? value.replaceAll('.', '').replaceAll(',', '.')
        : value;

    return double.parse(normalized);
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o preco.';
    }

    final normalized = value.contains(',')
        ? value.replaceAll('.', '').replaceAll(',', '.')
        : value;

    final price = double.tryParse(normalized);

    if (price == null || price <= 0) {
      return 'Informe um preco valido.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Novo item' : 'Editar item'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPhoto(),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: widget.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _categoryController.clear();
                    });
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Nova categoria personalizada',
                    hintText: 'Ex: Drinks, Porcoes, Sobremesas',
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titulo'),
                  validator: (value) =>
                      _requiredValidator(value, 'Informe o titulo.'),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descricao'),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      _requiredValidator(value, 'Informe a descricao.'),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preco',
                    prefixText: 'R\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: _priceValidator,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Salvar')),
      ],
    );
  }

  Widget _buildPhoto() {
    return InkWell(
      onTap: _processingPhoto ? null : _pickPhoto,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
          color: DsColors.adminBackground,
        ),
        child: _processingPhoto
            ? const Center(child: CircularProgressIndicator())
            : _photo.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 42),
                  SizedBox(height: 8),
                  Text('Selecionar foto'),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  ImageHelper.base64ToBytes(_photo),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image);
                  },
                ),
              ),
      ),
    );
  }
}
