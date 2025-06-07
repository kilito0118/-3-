// matarial.dart, map_api_services.dart, dart:ui, recommended_places_page 임포트 필요
import 'package:flutter/material.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/services/map_api_services.dart';
import 'dart:ui';
import 'recommended_places_page.dart';
import 'package:open_sw/services/current_location_service.dart';

class SetPlacePage extends StatefulWidget {
  // 활동번호
  final int activityNum;

  const SetPlacePage({
    super.key,
    required this.activityNum
  });

  @override
  State<SetPlacePage> createState() => _SetPlacePageState();
}

class _SetPlacePageState extends State<SetPlacePage> {
  final _controller = TextEditingController();
  List<Map<String, String>> places = [];

  Future<void> search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    try {
      final results = await findPlaces(query);
      setState(() => places = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: searchAppBar(controller: _controller, onSearch: search),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xFFF2F2F2)
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    topSearchAppBarSpacer(context),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () async {
                            final current = await getCurrentLocation();

                            if (!context.mounted) return;

                            if(current['success']){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecommendedPlacesPage(
                                    posName: '현재 위치',
                                    lat: current['lat'],
                                    lng: current['lng'],
                                    activityNum: widget.activityNum,
                                  ),
                                ),
                              );
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(current['error'])));
                            }


                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.centerLeft,
                              textStyle: contentsNormal()
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Icon(Icons.my_location, color: Colors.white,),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                '현재위치로 검색',
                              ),
                            ],
                          )
                      ),
                    ),
                    spacingBox(),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,

                      child: Column(
                        children: List.generate(places.length, (index) {
                          final place = places[index];
                          return SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RecommendedPlacesPage(
                                        posName: place['name']!,
                                        lat: double.parse(place['y']!),
                                        lng: double.parse(place['x']!),
                                        activityNum: widget.activityNum,
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place['name'] ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    Text(
                                      place['address'] ?? '',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.normal
                                      ),
                                    )
                                  ],
                                )
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 80,)
                  ],
                ),
              )
          )

      ),

    );
  }
}