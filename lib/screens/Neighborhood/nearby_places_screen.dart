import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constraints.dart';
import 'Response/nearby_response.dart';

class NearByPlacesScreen extends StatefulWidget {
  // const NearByPlacesScreen({Key? key}) : super(key: key);

  double latitude;
  double longitude;
  NearByPlacesScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);

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
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' + widget.latitude.toString() + ',' + widget.longitude.toString() + '&radius=' + radius + '&key=' + placesApi_Key);
    var response = await http.post(url);
    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text("Name: " + results.name!),
        Text("Location: " + results.geometry!.location!.lat.toString() + ", " + results.geometry!.location!.lng.toString()),
        // Text("Name: " + results.name!)
      ]),
    );
  }
}
