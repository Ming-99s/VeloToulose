import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/utils/timer_util.dart';
import 'package:velo_toulose/features/map/view/search_screen.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/map/widgets/build_station_marker_widget.dart';
import 'package:velo_toulose/features/ride/view/ride_active_screen.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/features/notification/view/notification_screen.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
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
    await viewModel.loadStations();

    if (viewModel.userLocation != null && mounted) {
      _mapController.move(viewModel.userLocation!, 15.0);
    }
  }

  // smooth fade + slide transition to search screen
void _goToSearch() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchScreen(mapController: _mapController), 
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _goRideActive() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RideActiveScreen(mapController: _mapController,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = context.watch<MapViewModel>();
    final rideViewModel = context.watch<RideViewModel>();

    return Stack(
      children: [
        // map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: mapViewModel.fallback,
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

            // user location dot
            if (mapViewModel.userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: mapViewModel.userLocation!,
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
                            boxShadow: const [
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

            // station markers
            if (mapViewModel.stations.isNotEmpty)
              MarkerLayer(
                markers: mapViewModel.stations.map((station) {
                  return Marker(
                    point: station.location,
                    width: 60,
                    height: 35,
                    child: GestureDetector(
                      onTap: () => mapViewModel.selectStation(station),
                      child: BuildStationMarkerWidget(station: station,hasActiveRide: rideViewModel.hasActiveRide,),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),

        // active ride banner — only show when ride is active
        if (rideViewModel.hasActiveRide)
          _buildRideActiveBanner(
            timerLabel: TimeUtils(activeRide: rideViewModel.activeRide).timerLabel,
            onTap: _goRideActive,
          ),

        // top bar: search + notifications
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // search bar with hero animation
                  Expanded(
                    child: Hero(
                      tag: 'search_bar',
                      child: Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: _goToSearch,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColor.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Search station...',
                                  style: TextStyle(
                                    color: AppColor.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications),
                        ),
                        // Red badge for unread count
                        Builder(
                          builder: (context) {
                            final unread = context.watch<NotificationViewModel>().unreadCount;
                            if (unread == 0) return const SizedBox.shrink();
                            return Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColor.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$unread',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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

Widget _buildRideActiveBanner({
  required String timerLabel,
  required VoidCallback onTap,
}) {
  return Positioned(
    bottom: 100,
    left: 0,
    right: 0,
    child: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(52, 255, 94, 0),
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.primaryLight,
                      ),
                      child: Icon(Icons.pedal_bike, color: AppColor.primary),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride Active',
                          style: TextStyle(
                            color: AppColor.background,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // real timer from RideViewModel
                        Text(timerLabel, style: AppTextStyle.buttonText),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.background,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
