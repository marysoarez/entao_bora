import 'package:flutter/material.dart';

class CreateFab extends StatefulWidget {
  final VoidCallback onCreateEvent;
  final VoidCallback onCreatePlace;

  const CreateFab({
    super.key,
    required this.onCreateEvent,
    required this.onCreatePlace,
  });

  @override
  State<CreateFab> createState() => _CreateFabState();
}

class _CreateFabState extends State<CreateFab>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (expanded)
          GestureDetector(
            onTap: () => setState(() => expanded = false),
            child: Container(color: Colors.black45),
          ),

        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: expanded
                  ? SizedBox(
                      width: 240,

                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Criar',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 8),

                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                minLeadingWidth: 32,
                                minTileHeight: 40,
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.event, size: 20),
                                title: const Text('Novo evento'),
                                onTap: () {
                                  setState(() => expanded = false);
                                  widget.onCreateEvent();
                                },
                              ),

                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                minLeadingWidth: 32,
                                minTileHeight: 40,
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.place, size: 20),
                                title: const Text('Novo estabelecimento'),
                                onTap: () {
                                  setState(() => expanded = false);
                                  widget.onCreatePlace();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            FloatingActionButton(
              heroTag: 'createFab',
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                turns: expanded ? 0.375 : 0,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
