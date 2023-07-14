import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constraints.dart';
import 'Response/nearby_response.dart';

class NearByPlacesScreen extends StatefulWidget {
  double latitude;
  double longitude;

  NearByPlacesScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NearByPlacesScreenState();
}

class NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String radius = "50";
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  void initState() {
    super.initState();
    getNearbyPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGrey,
      appBar: AppBar(
        backgroundColor: primaryRed,
        title: const Text("الأماكن القريبة"),
        centerTitle: true,
      ),
      body: (nearbyPlacesResponse.results != null)
          ? ListView.builder(
              itemCount: nearbyPlacesResponse.results!.length,
              itemBuilder: (BuildContext context, int index) {
                return nearbyPlacesWidget(nearbyPlacesResponse.results![index]);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void getNearbyPlaces() async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            widget.latitude.toString() +
            ',' +
            widget.longitude.toString() +
            '&radius=' +
            radius +
            '&key=' +
            placesApi_Key);
    var response = await http.post(url);
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (results.icon != null)
                Image.network(
                  results.icon!,
                  width: 24,
                  height: 24,
                ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      results.name!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      ),
                    ),
                    if (results.types != null && results.types!.isNotEmpty)
                      Text(
                        'الصنف: ${results.types!.map((type) => translations[type] ?? type).join('، ')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> translations = {
    'restaurant': 'مطعم',
    'cafe': 'مقهى',
    'gym': 'نادي رياضي',
    'health': 'صحة',
    'food': 'طعام',
    'store': 'محل تجاري',
    'point_of_interest': 'مكان مثير للإهتمام',
    'establishment': 'مؤسسة',
    'supermarket': 'سوبرماركت',
    'mosque': 'مسجد',
    'place_of_worship': 'مكان عبادة',
    'route': 'شارع/طريق',
    'lodging': 'مسكن',
  };
}
