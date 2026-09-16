import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_style.dart';

class HomeEventCard extends StatelessWidget {
  const HomeEventCard({super.key, required this.event, required this.onTap});
  final EventEntity event;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => _Card(
    onTap: onTap,
    radius: 12,
    hoverLift: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            HomePhoto(event.coverImage, height: 210),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xDD151515),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  event.ticket.isFree ? 'Entrada gratuita' : 'Ingressos',
                  style: HomeStyle.type(10),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd(
                  'pt_BR',
                ).add_Hm().format(event.startDate.toLocal()),
                style: HomeStyle.type(
                  11,
                  color: HomeStyle.brand,
                  weight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  event.title,
                  style: HomeStyle.type(
                    19,
                    weight: FontWeight.w700,
                    tracking: -.855,
                  ),
                ),
              ),
              Row(
                children: [
                  const HomeIcon(
                    HomeGlyph.pin,
                    size: 14,
                    color: HomeStyle.muted,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      event.locationName,
                      style: HomeStyle.type(12, color: HomeStyle.muted),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.only(top: 15),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: HomeStyle.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.musicGenres
                            .take(2)
                            .map((g) => g.label)
                            .join(' · '),
                        style: HomeStyle.type(11, color: HomeStyle.muted),
                      ),
                    ),
                    const HomeIcon(
                      HomeGlyph.arrow,
                      size: 18,
                      color: HomeStyle.muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class HomePlaceCard extends StatelessWidget {
  const HomePlaceCard({super.key, required this.place, required this.onTap});
  final PlaceEntity place;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => _Card(
    onTap: onTap,
    radius: 10,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: HomePhoto(
              place.photos.isEmpty ? '' : place.photos.first,
              height: 70,
              width: 70,
              iconSize: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.type.name,
                  style: HomeStyle.type(12, color: HomeStyle.muted),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    place.name,
                    style: HomeStyle.type(
                      19,
                      weight: FontWeight.w700,
                      tracking: -.855,
                    ),
                  ),
                ),
                Text(
                  place.address.neighborhood ?? place.address.displayName,
                  style: HomeStyle.type(12, color: HomeStyle.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const HomeIcon(HomeGlyph.arrow, size: 24),
        ],
      ),
    ),
  );
}

class _Card extends StatefulWidget {
  const _Card({
    required this.child,
    required this.onTap,
    required this.radius,
    this.hoverLift = false,
  });
  final Widget child;
  final VoidCallback onTap;
  final double radius;
  final bool hoverLift;
  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _hover = false, _focus = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(
        0,
        _hover && widget.hoverLift ? -4 : 0,
        0,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: HomeStyle.box(
        radius: widget.radius,
        border: _focus
            ? HomeStyle.accent
            : _hover
            ? const Color(0xFF555555)
            : const Color(0xFF292929),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onFocusChange: (v) => setState(() => _focus = v),
          child: widget.child,
        ),
      ),
    ),
  );
}
