import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/map/widgets/search_bar.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  static const LatLng defaultCenter = LatLng(11.5564, 104.9282);
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLocation();
    });
  }

  Future<void> _loadLocation() async {
    final viewModel = context.read<MapViewModel>();

    await viewModel.getUserLocation();

    if (viewModel.userLocation != null && mounted) {
      _mapController.move(viewModel.userLocation!, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: defaultCenter,
            initialZoom: 15.0,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.velo_toulose',
              maxZoom: 20,
            ),

            if (viewModel.userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: viewModel.userLocation!,
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(35, 33, 149, 243),
                          ),
                        ),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent,
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),

Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: SearchBarVelo()),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
