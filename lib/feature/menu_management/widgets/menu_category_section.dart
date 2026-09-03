import 'package:entao_bora/feature/menu_management/widgets/category_header.dart';
import 'package:entao_bora/feature/menu_management/widgets/empt_category.dart';
import 'package:entao_bora/feature/menu_management/widgets/menu_item_tile.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:flutter/material.dart';

class MenuCategorySection extends StatelessWidget {
  final String title;
  final List<MenuItemEntity> items;
  final VoidCallback onAdd;
  final ValueChanged<MenuItemEntity> onEdit;
  final ValueChanged<MenuItemEntity> onDelete;

  const MenuCategorySection({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryHeader(
          title: title,
          count: items.length,
        ),

        const SizedBox(height: 10),

        if (items.isEmpty)
          EmptyCategory(
            onAdd: onAdd,
          )
        else
          Card(
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  MenuItemTile(
                    item: items[index],
                    onEdit: () => onEdit(items[index]),
                    onDelete: () => onDelete(items[index]),
                  ),
                  if (index != items.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}