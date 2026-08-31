import 'dart:async';

import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:flutter/material.dart';

class AddressAutocompleteField extends StatefulWidget {
  const AddressAutocompleteField({
    super.key,
    this.initialValue,
    required this.search,
    required this.onSelected,
    this.label = 'Endereço',
    this.hint = 'Rua, bairro ou estabelecimento',
  });

  final AddressEntity? initialValue;

  final Future<List<AddressEntity>> Function(String query) search;

  final ValueChanged<AddressEntity> onSelected;

  final String label;
  final String hint;

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  late final TextEditingController controller;

  Timer? debounce;

  bool loading = false;

  List<AddressEntity> results = [];

  AddressEntity? selected;

  @override
  void initState() {
    super.initState();

    selected = widget.initialValue;

    controller = TextEditingController(text: selected?.fullAddress ?? '');
  }

  @override
  void dispose() {
    debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> _search(String value) async {
    final query = value.trim();

    if (query.length < 3) {
      setState(() {
        results = [];
      });
      return;
    }

    setState(() {
      loading = true;
    });

    final addresses = await widget.search(query);

    if (!mounted) return;

    setState(() {
      loading = false;
      results = addresses;
    });
  }

  void _onChanged(String value) {
    selected = null;

    debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () => _search(value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 12),

        TextField(
          controller: controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();

                      setState(() {
                        selected = null;
                        results = [];
                      });
                    },
                  )
                : null,
          ),
        ),

        if (loading && selected == null) ...[
          const SizedBox(height: 8),
          const _AddressSuggestionsSkeleton(),
        ] else if (selected != null) ...[
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(child: Text(selected!.fullAddress)),
              ],
            ),
          ),
        ] else if (results.isNotEmpty) ...[
          const SizedBox(height: 8),

          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (_, index) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final address = results[index];

                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(address.displayName),
                  subtitle: Text(address.fullAddress),
                  onTap: () {
                    controller.text = address.fullAddress;

                    setState(() {
                      selected = address;
                      results.clear();
                    });

                    widget.onSelected(address);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _AddressSuggestionsSkeleton extends StatelessWidget {
  const _AddressSuggestionsSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(3, (index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    _SkeletonBox(
                      width: 40,
                      height: 40,
                      color: baseColor,
                      borderRadius: 20,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.82,
                            child: _SkeletonBox(height: 14, color: baseColor),
                          ),
                          const SizedBox(height: 8),
                          FractionallySizedBox(
                            widthFactor: 0.58,
                            child: _SkeletonBox(
                              height: 12,
                              color: highlightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < 2) const Divider(height: 1),
            ],
          );
        }),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.color,
    this.width,
    this.borderRadius = 6,
  });

  final double? width;
  final double height;
  final Color color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
