import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gorent_application1/screens/Map/places_search.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';
import '../../constraints.dart';
import '../../guest_bottom_nav.dart';
import '../../owner_bottom_nav_bar.dart';
import '../../user_bottom_nav_bar.dart';
import '../Models_Folder/Map_Models/place.dart';

class MapScreen extends StatefulWidget {
  final int currentIndex;

  const MapScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<PlaceSearch> places = [];
  late GoogleMapController mapController;
  late PlaceSearch placeSuggestion;
  Completer<GoogleMapController> placesController = Completer();

  List<Marker> markers = [];
  bool isDisplayed2 = false;
  String selectedPlaceTitle = '';
  String selectedPlaceCity = '';
  String selectedPlaceType = '';
  String selectedPlaceNumRooms = '';
  String selectedPlaceNumBathrooms = '';
  String selectedPlaceSize = '';
  String selectedPlaceAddress1 = '';
  List<String> selectedImageUrls = [];

  final DatabaseReference rentRef =
      FirebaseDatabase.instance.reference().child('rent');
  final DatabaseReference saleRef =
      FirebaseDatabase.instance.reference().child('sale');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentIndex = widget.currentIndex;
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    bool isDisplayed = true;

    return Container(
      color: primaryGrey,
      child: SizedBox(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Scaffold(
                bottomNavigationBar: currentIndex == 1
                    ? const BottomNavBar(
                        currentIndex: 2,
                      )
                    : currentIndex == 0
                        ? const OwnerBottomNavBar(
                            currentIndex: 2,
                          )
                        : const GuestBottomNavBar(
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
                    placesController.complete(controller);
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: InputBorder.none,
                      hintText: 'البحث عن مدينة',
                      hintTextDirection: TextDirection.rtl,
                      prefixIcon: Icon(Icons.close),
                    ),
                    onChanged: (value) {
                      applicationBloc.searchPlaces(value);
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 91,
              left: 10,
              right: 10,
              child: Stack(
                children: [
                  if (applicationBloc.searchResults != null &&
                      applicationBloc.searchResults.length != 0)
                    Container(
                      height: 410.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.6),
                          backgroundBlendMode: BlendMode.darken),
                    ),
                  if (applicationBloc.searchResults != null)
                    Container(
                      height: 300.0,
                      child: Material(
                        color: Colors.transparent,
                        child: ListView.builder(
                            itemCount: applicationBloc.searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  applicationBloc
                                      .searchResults[index].description,
                                  style: TextStyle(
                                      color: primaryWhite, fontSize: 18),
                                ),
                                onTap: () {
                                  applicationBloc.setSelectedLocation(
                                      applicationBloc
                                          .searchResults[index].placeId);
                                  applicationBloc.clearSearchResults();
                                  setState(() {
                                    isDisplayed = false;
                                  });
                                },
                              );
                            }),
                      ),
                    ),
                ],
              ),
            ),
            //here for apartment widget
            Positioned(
              bottom: 70,
              left: 10,
              right: 10,
              child: isDisplayed2
                  ? Container(
                      width: 310,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 345,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              image: DecorationImage(
                                image: NetworkImage(selectedImageUrls.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 13.0),
                                child: Text(
                                  "\$" + selectedPlaceTitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primaryRed,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 13.0),
                                child: Text(
                                  selectedPlaceCity +
                                      "، " +
                                      selectedPlaceAddress1,
                                  style: TextStyle(
                                    fontFamily: 'Scheherazade_New',
                                    fontSize: 15,
                                    color: primaryRed,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/Red_bedroom.png'),
                                      width: 20,
                                      height: 18,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 6.0),
                                    child: Text(
                                      selectedPlaceNumRooms,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/Red_bathroom.png'),
                                      width: 20,
                                      height: 18,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      selectedPlaceNumBathrooms,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/Red_size.png'),
                                      width: 20,
                                      height: 18,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 75.0),
                                    child: Text(
                                      selectedPlaceSize,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 13.0),
                                child: Text(
                                  selectedPlaceType,
                                  style: TextStyle(
                                    fontFamily: 'Scheherazade_New',
                                    fontSize: 12,
                                    color: primaryRed,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> readRentData() async {
    rentRef.onValue.listen((event) {
      markers.clear();
      if (event.snapshot.value != null) {
        if (event.snapshot.value is Map) {
          Map<dynamic, dynamic> rentData =
              event.snapshot.value as Map<dynamic, dynamic>;
          rentData.forEach((key, value) {
            if (value is Map) {
              List<String> imageUrls = [];

              final images = (value['images'] as Map<dynamic, dynamic>);

              imageUrls =
                  images.values.map((value) => value.toString()).toList();
              double latitude = double.parse(value['latitude'].toString());
              double longitude = double.parse(value['longitude'].toString());
              int price = int.parse(value['price'].toString());
              String city = (value['city'].toString());
              String type = (value['type'].toString());
              int numRooms = int.parse(value['numRooms'].toString());
              int numBathrooms = int.parse(value['numBathrooms'].toString());
              int size = int.parse(value['size'].toString());
              String address1 = (value['address1'].toString());

              setState(() {
                markers.add(
                  Marker(
                    markerId: MarkerId(key.toString()),
                    position: LatLng(latitude, longitude),
                    onTap: () {
                      setState(() {
                        selectedPlaceTitle = price.toString();
                        selectedPlaceCity = city.toString();
                        selectedPlaceType = type.toString();
                        selectedPlaceNumRooms = numRooms.toString();
                        selectedPlaceNumBathrooms = numBathrooms.toString();
                        selectedPlaceSize = size.toString();
                        selectedPlaceAddress1 = address1.toString();
                        selectedImageUrls = imageUrls;
                        isDisplayed2 = true;
                      });
                    },
                  ),
                );
              });
            }
          });
        }
      }
    });
  }

  Future<void> readSaleData() async {
    saleRef.onValue.listen((event) {
      markers.clear();
      if (event.snapshot.value != null) {
        if (event.snapshot.value is Map) {
          Map<dynamic, dynamic> saleData =
              event.snapshot.value as Map<dynamic, dynamic>;
          saleData.forEach((key, value) {
            if (value is Map) {
              List<String> imageUrls = [];

              final images = (value['images'] as Map<dynamic, dynamic>);

              imageUrls =
                  images.values.map((value) => value.toString()).toList();
              double latitude = double.parse(value['latitude'].toString());
              double longitude = double.parse(value['longitude'].toString());
              int price = int.parse(value['price'].toString());
              String city = (value['city'].toString());
              String type = (value['type'].toString());
              int numRooms = int.parse(value['numRooms'].toString());
              int numBathrooms = int.parse(value['numBathrooms'].toString());
              int size = int.parse(value['size'].toString());
              String address1 = (value['address1'].toString());
              setState(() {
                markers.add(
                  Marker(
                    markerId: MarkerId(key.toString()),
                    position: LatLng(latitude, longitude),
                    onTap: () {
                      setState(() {
                        selectedPlaceTitle = price.toString();
                        selectedPlaceCity = city.toString();
                        selectedPlaceType = type.toString();
                        selectedPlaceNumRooms = numRooms.toString();
                        selectedPlaceNumBathrooms = numBathrooms.toString();
                        selectedPlaceSize = size.toString();
                        selectedPlaceAddress1 = address1.toString();
                        selectedImageUrls = imageUrls;
                        isDisplayed2 = true;
                      });
                    },
                  ),
                );
              });
            }
          });
        }
      }
    });
  }

  Future<void> goToPlace(Place place) async {
    final GoogleMapController goToController = await placesController.future;
    goToController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          place.geometry.location.lat,
          place.geometry.location.long,
        ),
        zoom: 14.0,
      ),
    ));
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        goToPlace(place);
      }
    });
    readRentData();
    readSaleData();
    super.initState();
  }
}
