import 'dart:async';
import 'dart:ui' as ui;
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import '../pages/map_seleton.dart';
import 'home_style.dart';

class HomeMapItem {
  const HomeMapItem(this.name, this.route, this.position);
  final String name, route;
  final google.LatLng position;
}

/// Exact coordinates are intentionally used instead of distance clustering.
Map<google.LatLng, List<HomeMapItem>> groupHomeMapItems(
  List<PlaceEntity> places,
  List<EventEntity> events,
) {
  final groups = <google.LatLng, List<HomeMapItem>>{};
  void add(String name, String route, LocationEntity location) {
    final point = google.LatLng(location.latitude, location.longitude);
    groups.putIfAbsent(point, () => []).add(HomeMapItem(name, route, point));
  }

  for (final p in places) {
    add(p.name, '/place/${p.slug.isEmpty ? p.id : p.slug}', p.address.location);
  }
  for (final e in events.where((e) => e.placeId?.isNotEmpty != true)) {
    add(
      e.title,
      '/events/${e.slug.isEmpty ? e.id : e.slug}',
      e.address.location,
    );
  }
  return groups;
}

class MapSection extends StatefulWidget {
  const MapSection({
    super.key,
    required this.places,
    required this.events,
    this.location,
    this.height = 520,
    this.onNavigate,
    this.mapBuilder,
  });
  final List<PlaceEntity> places;
  final List<EventEntity> events;
  final LocationEntity? location;
  final double height;
  final ValueChanged<String>? onNavigate;
  final Widget Function(google.GoogleMap)? mapBuilder;
  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  google.GoogleMapController? _controller;
  static const _center = google.LatLng(-22.9068, -43.1729);
  bool _idle = false;
  String? _error;
  int _attempt = 0;
  Timer? _timeout;
  google.LatLng? _selected;
  final Map<int, google.BitmapDescriptor> _numberedPins = {};
  final Set<int> _pendingPins = {};
  Map<google.LatLng, List<HomeMapItem>> get _groups =>
      groupHomeMapItems(widget.places, widget.events);
  void _navigate(String route) {
    if (widget.onNavigate != null) {
      widget.onNavigate!(route);
    } else {
      Modular.to.pushNamed(route);
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  void _startTimeout() {
    _timeout?.cancel();
    _timeout = Timer(const Duration(seconds: 25), () {
      if (mounted && !_idle) {
        setState(() => _error = 'Não foi possível carregar o mapa.');
      }
    });
  }

  @override
  void didUpdateWidget(covariant MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final groups = _groups;
    if (!groups.containsKey(_selected)) _selected = null;
    if (oldWidget.location != widget.location ||
        !_samePoints(
          groupHomeMapItems(oldWidget.places, oldWidget.events).keys,
          groups.keys,
        )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fit();
      });
    }
  }

  bool _samePoints(Iterable<google.LatLng> a, Iterable<google.LatLng> b) =>
      a.length == b.length && a.toSet().containsAll(b);
  Future<void> _fit() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      if (widget.location != null) {
        final location = widget.location!;
        await controller.animateCamera(
          google.CameraUpdate.newLatLngZoom(
            google.LatLng(location.latitude, location.longitude),
            14,
          ),
        );
        return;
      }
      final points = _groups.keys.toList();
      if (points.length <= 1) {
        await controller.animateCamera(
          google.CameraUpdate.newLatLngZoom(_center, 11),
        );
        return;
      }
      var minLat = points.first.latitude, maxLat = minLat;
      var minLng = points.first.longitude, maxLng = minLng;
      for (final point in points.skip(1)) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }
      await controller.animateCamera(
        google.CameraUpdate.newLatLngBounds(
          google.LatLngBounds(
            southwest: google.LatLng(minLat, minLng),
            northeast: google.LatLng(maxLat, maxLng),
          ),
          50,
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível posicionar o mapa.');
      }
    }
  }

  void _retry() {
    _controller?.dispose();
    _controller = null;
    setState(() {
      _attempt++;
      _idle = false;
      _error = null;
    });
    _startTimeout();
  }

  // The cross-platform Marker API has no label. Use a bitmap only for groups;
  // single items keep Google's default marker and the map keeps its own style.
  Future<void> _numberedPin(int count) async {
    if (_numberedPins.containsKey(count) || !_pendingPins.add(count)) return;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(2);
    final path = Path()
      ..moveTo(16, 42)
      ..cubicTo(12, 34, 1, 24, 1, 16)
      ..arcToPoint(const Offset(31, 16), radius: const Radius.circular(15))
      ..cubicTo(31, 24, 20, 34, 16, 42)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFEA4335));
    final text = TextPainter(
      text: TextSpan(
        text: '$count',
        style: HomeStyle.type(13, color: Colors.white, weight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset((32 - text.width) / 2, 16 - text.height / 2));
    final picture = recorder.endRecording();
    final image = await picture.toImage(64, 88);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();
    _pendingPins.remove(count);
    if (!mounted || bytes == null) return;
    setState(
      () => _numberedPins[count] = google.BitmapDescriptor.bytes(
        bytes.buffer.asUint8List(),
        width: 32,
        height: 44,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groups;
    final selected = groups[_selected];
    for (final group in groups.values.where((g) => g.length > 1)) {
      _numberedPin(group.length);
    }
    final markers = groups.entries
        .map(
          (entry) => google.Marker(
            icon:
                _numberedPins[entry.value.length] ??
                google.BitmapDescriptor.defaultMarker,
            markerId: google.MarkerId(
              '${entry.key.latitude},${entry.key.longitude}',
            ),
            position: entry.key,
            infoWindow: google.InfoWindow(
              title: entry.value.length > 1
                  ? '${entry.value.length} neste endereço'
                  : entry.value.first.name,
            ),
            consumeTapEvents: true,
            onTap: () {
              if (entry.value.length == 1) {
                _navigate(entry.value.first.route);
              } else {
                setState(() => _selected = entry.key);
              }
            },
          ),
        )
        .toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildMap(
                    google.GoogleMap(
                      key: ValueKey(_attempt),
                      initialCameraPosition: google.CameraPosition(
                        target: widget.location == null
                            ? _center
                            : google.LatLng(
                                widget.location!.latitude,
                                widget.location!.longitude,
                              ),
                        zoom: widget.location == null ? 11 : 14,
                      ),
                      markers: markers,
                      cloudMapId:
                          const String.fromEnvironment(
                            'GOOGLE_MAPS_MAP_ID',
                          ).isEmpty
                          ? null
                          : const String.fromEnvironment('GOOGLE_MAPS_MAP_ID'),
                      mapType: google.MapType.normal,
                      onMapCreated: (controller) {
                        _controller = controller;
                        _fit();
                      },
                      onCameraIdle: () {
                        if (!mounted) return;
                        _timeout?.cancel();
                        if (!_idle) {
                          setState(() {
                            _idle = true;
                            _error = null;
                          });
                        }
                      },
                    ),
                  ),
                ),
                if (!_idle && _error == null)
                  const Positioned.fill(
                    child: IgnorePointer(child: MapSkeleton()),
                  ),
                if (_error != null)
                  Positioned.fill(
                    child: ColoredBox(
                      color: const Color(0xFF101217),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _error!,
                                style: HomeStyle.type(14),
                                textAlign: TextAlign.center,
                              ),
                              HomeAction('Tentar novamente', onTap: _retry),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (selected != null && selected.length > 1)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(24),
            decoration: HomeStyle.box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Neste endereço',
                  style: HomeStyle.type(19, weight: FontWeight.w700),
                ),
                ...selected.map(
                  (item) => HomeAction(
                    item.name,
                    onTap: () => _navigate(item.route),
                    icon: HomeGlyph.arrow,
                    trailingIcon: true,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildMap(google.GoogleMap map) => widget.mapBuilder?.call(map) ?? map;
}
