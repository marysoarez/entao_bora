import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:entao_bora/feature/places/presentation/widgets/address_step_widget.dart';
import 'package:entao_bora/feature/places/presentation/widgets/genre_step_widget.dart';
import 'package:entao_bora/feature/places/presentation/widgets/oppening_hours_widget.dart';
import 'package:entao_bora/feature/places/presentation/widgets/photo_step_widget.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CreatePlacePage extends StatefulWidget {
  const CreatePlacePage({super.key});

  @override
  State<CreatePlacePage> createState() => _CreatePlacePageState();
}

class _CreatePlacePageState extends State<CreatePlacePage> {
  late final CreatePlaceViewModel vm;

  final controller = PageController();

  int page = 0;

  static const totalPages = 5;

  bool get isLastPage => page == totalPages - 1;

  @override
  void initState() {
    super.initState();

    vm = Modular.get<CreatePlaceViewModel>();
  }

  Future<void> next() async {
    if (isLastPage) {
      final success = await vm.save();

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.error ?? 'Erro ao salvar.'),
          ),
        );
      }

      return;
    }

    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void previous() {
    if (page == 0) {
      Navigator.pop(context);
      return;
    }

    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo estabelecimento'),
      ),
      body: Observer(
        builder: (_) {
          return Column(
            children: [
              LinearProgressIndicator(
                value: (page + 1) / totalPages,
              ),

              Expanded(
                child: PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      page = value;
                    });
                  },
                  children: [
                    PlaceInfoStep(vm: vm),
                    AddressStep(vm: vm),
                    GenreStep(vm: vm),
                    OpeningHoursStep(vm: vm),
                    PhotoStep(vm: vm),
                  ],
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: previous,
                          child: Text(
                            page == 0 ? 'Cancelar' : 'Voltar',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: vm.loading ? null : next,
                          child: vm.loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isLastPage ? 'Salvar' : 'Próximo',
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
      ),
    );
  }
}