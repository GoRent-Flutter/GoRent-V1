import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gorent_application1/screens/Map/places_search.dart';

import '../../constraints.dart';
import '../../user_bottom_nav_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<PlaceSearch> places = [];
  late GoogleMapController mapController;
  late PlaceSearch placeSuggestion;
  final List<Marker> markers = [
    const Marker(
      markerId: MarkerId('place1'),
      position: LatLng(31.92157, 35.20329),
      infoWindow: InfoWindow(title: 'Place 1'),
    ),
    const Marker(
      markerId: MarkerId('place2'),
      position: LatLng(31.92583, 35.22524),
      infoWindow: InfoWindow(title: 'Place 2'),
    ),
    const Marker(
      markerId: MarkerId('place3'),
      position: LatLng(31.92105, 35.21220),
      infoWindow: InfoWindow(title: 'Place 3'),
    ),
  ];



 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Container(
      color: primaryGrey,
     
      child: SizedBox(
        child: Stack(
          children: <Widget>[
            const Positioned(
              child: Scaffold(
                bottomNavigationBar: BottomNavBar(
                  currentIndex: 2,
                ),
              ),
            ),
            Positioned(
              child: SizedBox(
                height: size.height - 60,
                child: GoogleMap(
                  onMapCreated: (controller) async {
                    String style = await DefaultAssetBundle.of(context)
                        .loadString('assets/map_style.json');
                    controller.setMapStyle(style);
                    setState(() {
                      mapController = controller;
                    });
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(31.92157, 35.20329),
                    zoom: 10,
                  ),
                  markers: Set<Marker>.of(markers),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Material(
                child: Container(
                  height: 50,
                  width: size.width - 50,
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: InputBorder.none,
                      hintText: 'البحث عن مدينة',
                      hintTextDirection: TextDirection.rtl,
                      prefixIcon: Icon(Icons.close),
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
