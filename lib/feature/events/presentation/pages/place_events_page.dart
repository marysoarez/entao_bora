// import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
// import 'package:entao_bora/feature/events/presentation/widgets/event_card_widget.dart';
// import 'package:entao_bora/feature/events/presentation/widgets/event_mini_card.dart';
// import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_modular/flutter_modular.dart';

// class PlaceEventsPage extends StatefulWidget {
//   const PlaceEventsPage({super.key, required this.place});

//   final PlaceEntity place;

//   @override
//   State<PlaceEventsPage> createState() => _PlaceEventsPageState();
// }

// class _PlaceEventsPageState extends State<PlaceEventsPage> {
//   final vm = Modular.get<PlaceEventsViewModel>();

//   @override
//   void initState() {
//     super.initState();
//     vm.load(widget.place.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.place.name)),
//       body: Observer(
//         builder: (_) {
//           if (vm.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (vm.error != null) {
//             return Center(child: Text(vm.error!));
//           }

//           if (vm.events.isEmpty) {
//             return const Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.event_busy, size: 72),
//                   SizedBox(height: 16),
//                   Text(
//                     'Nenhum evento encontrado.',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: vm.events.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (_, index) {
//               final event = vm.events[index];

//               return EventMiniCard(event: event, place: widget.place);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
