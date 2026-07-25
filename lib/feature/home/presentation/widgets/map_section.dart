import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/events/presentation/pages/place_events_page.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/presentation/place_details_page.dart';
import 'package:entao_bora/shared/config/map_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
class MapSection extends StatelessWidget {
  final LocationEntity currentLocation;
  final List<PlaceEntity> places;

  const MapSection({
    super.key,
    required this.currentLocation,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
        initialZoom: 11,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: MapConfig.tileUrl,
          subdomains: MapConfig.subdomains,
          userAgentPackageName: 'com.entaobora',
        ),
    
        MarkerLayer(markers: _buildCurrentLocationMarker()),
    
        MarkerLayer(markers: _buildPlacesMarkers(context)),
      ],
    );
  }

  List<Marker> _buildCurrentLocationMarker() {
    return [
      Marker(
        width: 35,
        height: 35,
        point: LatLng(currentLocation.latitude, currentLocation.longitude),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: const Icon(Icons.my_location, color: Colors.white, size: 28),
        ),
      ),
    ];
  }

  List<Marker> _buildPlacesMarkers(BuildContext context) {
    return places.map((place) {
      return Marker(
        width: 45,
        height: 45,
        point: LatLng(
          place.address.location.latitude,
          place.address.location.longitude,
        ),
        child: GestureDetector(
          onTap: () { Modular.to.pushNamed(
                            '/places/events',
                            arguments: place,
                          );},
          // onTap: () => _showEvent(context, place),
          child: const Icon(Icons.location_pin, color: Colors.red, size: 45),
        ),
      );
    }).toList();
  }

  void _showEvent(BuildContext context, PlaceEntity place) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (place.photos.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      place.photos.first,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 20),

                Text(
                  "🎸 Evento em destaque",
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  "Evento ainda não informado",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 6),

                Text(
                  place.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text(place.address.fullAddress)),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.celebration),
                    label: const Text("ENTÃO BORA"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Em breve você poderá confirmar presença.",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.event),
                    label: const Text("Ver agenda da casa"),
                    onPressed: () {
                      Navigator.pop(context);

                      _showPlace(context, place);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPlace(BuildContext context, PlaceEntity place) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            children: [
              Text(
                place.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                place.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(place.address.fullAddress)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsPage(place: place),
                      ),
                    );
                  },
                  child: const Text('Ver detalhes'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
