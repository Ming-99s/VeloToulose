import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/map/widgets/search_tile.dart';
import 'package:velo_toulose/models/station.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key,required this.mapController});
  final MapController mapController;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Station> _results = [];

  @override
  void initState() {
    super.initState();
    // show all stations on open
    _results = context.read<MapViewModel>().stations;

    _controller.addListener(() {
      _search(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    final all = context.read<MapViewModel>().stations;
    setState(() {
      if (query.isEmpty) {
        _results = all;
      } else {
        _results = all
            .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

void _selectStation(Station station) {
    context.read<MapViewModel>().selectStation(station);

    // move map to station location after popping back
    Navigator.pop(context);

    // small delay to let the screen transition finish first
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.mapController.move(station.location, 17.0); // zoom in on station
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // search bar row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  // back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: AppColor.primary),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // search input with hero tag matching the search bar
                  Expanded(
                    child: Hero(
                      tag: 'search_bar',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: AppColor.textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Search station...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColor.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              if (_controller.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    _search('');
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: AppColor.textSecondary,
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // results count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_results.length} stations found',
                  style: AppTextStyle.subheading,
                ),
              ),
            ),

            // station list
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: AppColor.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No stations found',
                            style: AppTextStyle.subheading,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final station = _results[index];
                        return StationTile(
                          station: station,
                          onTap: () => _selectStation(station),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

