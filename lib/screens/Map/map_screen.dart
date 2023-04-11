import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constraints.dart';
import '../../user_bottom_nav_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
//  Future<void> _showSearchDialog() async {
//     var p = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: Constants.apiKey,
//         mode: Mode.fullscreen,
//         language: "ar",
//         region: "ar",
//         offset: 0,
//         hint: "Type here...",
//         radius: 1000,
//         types: [],
//         strictbounds: false,
//         components: [Component(Component.country, "ar")]);
//     _getLocationFromPlaceId(p!.placeId!);
//   }

//   Future<void> _getLocationFromPlaceId(String placeId) async {
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: Constants.apiKey,
//       apiHeaders: await GoogleApiHeaders().getHeaders(),
//     );

//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);

//     _animateCamera(LatLng(detail.result.geometry!.location.lat,
//         detail.result.geometry!.location.lng));

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

  // final searchController = TextEditingController();

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
          ],
        ),
      ),
     
  
    );
    
  }
}
