import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _isBeaconMode = false;

  // New Delhi Center
  final LatLng _center = const LatLng(28.6139, 77.2090);

  // Fake Responder Locations (around the center)
  final List<LatLng> _responders = [
    const LatLng(28.6160, 77.2110), // North East
    const LatLng(28.6120, 77.2070), // South West
    const LatLng(28.6150, 77.2050), // North West
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // 1. OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              minZoom: 3.0,
              maxZoom: 18.0,
              // Keep map within reasonable bounds if needed, but for now world is fine
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.resq_app',
                // Attribution is usually required for OSM/CartoDB
              ),
              MarkerLayer(
                markers: [
                  // User Marker (Pulse + Pin)
                  Marker(
                    point: _center,
                    width: 80,
                    height: 80,
                    child: const _UserMarker(),
                  ),
                  // Responder Markers
                  for (int i = 0; i < _responders.length; i++)
                    Marker(
                      point: _responders[i],
                      width: 40,
                      height: 40,
                      child: _ResponderMarker(
                        type: i % 2 == 0 ? 'Police' : 'Medic',
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 2. Attribution (Minimal, bottom right)
          Positioned(
            bottom: 4,
            right: 4,
            child: Text(
              '© OpenStreetMap, © CartoDB',
              style: GoogleFonts.inter(
                fontSize: 8,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),

          // 3. Header Actions (Back + Beacon)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  CircleAvatar(
                    backgroundColor: AppTheme.surface.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Beacon Mode Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _isBeaconMode
                            ? AppTheme.primaryAction
                            : Colors.white24,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                              Icons.flashlight_on,
                              color: _isBeaconMode
                                  ? AppTheme.primaryAction
                                  : Colors.white54,
                              size: 20,
                            )
                            .animate(target: _isBeaconMode ? 1 : 0)
                            .shimmer(duration: 1.seconds, color: Colors.white),

                        const SizedBox(width: 8),
                        Text(
                          'BEACON MODE',
                          style: GoogleFonts.inter(
                            color: _isBeaconMode
                                ? AppTheme.primaryAction
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isBeaconMode,
                          onChanged: (value) async {
                            try {
                              if (value) {
                                await TorchLight.enableTorch();
                              } else {
                                await TorchLight.disableTorch();
                              }
                              setState(() {
                                _isBeaconMode = value;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not control flashlight'),
                                ),
                              );
                              if (mounted) {
                                setState(() {
                                  _isBeaconMode = false;
                                });
                              }
                            }
                          },
                          activeColor: AppTheme.primaryAction,
                          activeTrackColor: AppTheme.primaryAction.withOpacity(
                            0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Floating Recenter Button
          Positioned(
            bottom: 140, // Above bottom sheet/nav or PTT
            right: 16,
            child: FloatingActionButton(
              heroTag: 'recenter_btn',
              backgroundColor: AppTheme.surface,
              onPressed: () {
                _mapController.move(_center, 15.0);
              },
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Pulse Effect
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryAction.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              duration: 1500.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.5, 1.5),
            )
            .fadeOut(duration: 1500.ms),

        // Pin Icon
        Icon(Icons.location_on, color: AppTheme.primaryAction, size: 40)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              duration: 1000.ms,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
            ),
      ],
    );
  }
}

class _ResponderMarker extends StatelessWidget {
  final String type; // 'Police' or 'Medic'

  const _ResponderMarker({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = type == 'Police' ? Colors.blue : Colors.green;
    final icon = type == 'Police' ? Icons.local_police : Icons.medical_services;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
