// import 'package:flutter/material.dart';

// class RockPulseMarker extends StatefulWidget {
//   final int pulse;
//   final VoidCallback onTap;
//   final IconData icon;
//   const RockPulseMarker({
//     super.key,
//     required this.pulse,
//     required this.onTap,
//     required this.icon,
//   });

//   @override
//   State<RockPulseMarker> createState() => _RockPulseMarkerState();
// }

// class _RockPulseMarkerState extends State<RockPulseMarker>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   double get maxRadius {
//     if (widget.pulse > 5) return 70;
//     if (widget.pulse > 4) return 60;
//     if (widget.pulse > 3) return 50;
//     if (widget.pulse > 1) return 40;

//     return 32;
//   }

//   Color get pulseColor {
//     if (widget.pulse > 5) return Colors.red;
//     if (widget.pulse > 4) return Colors.orange;
//     if (widget.pulse > 3) return Colors.yellow;
//     if (widget.pulse > 1) return Colors.green;

//     return Colors.blueGrey;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: AnimatedBuilder(
//         animation: controller,
//         builder: (_, __) {
//           final value = controller.value;

//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               // Onda
//               Container(
//                 width: maxRadius * value,
//                 height: maxRadius * value,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: pulseColor.withOpacity((1 - value) * .30),
//                 ),
//               ),

//               // Marcador
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: pulseColor, width: 2),
//                 ),
//                 child: Icon(widget.icon, color: pulseColor),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
