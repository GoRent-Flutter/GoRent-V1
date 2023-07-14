import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BuyList/buylist_screen.dart';
import '../ContactOwner/contact_owner.dart';
import '../../constraints.dart';
import '../MachineLearning/salePredModel.dart';
import '../Neighborhood/nearby_places_screen.dart';
import '../ReserveAppointment/reserveappointment_screen.dart';

class ItemDetailBuy extends StatefulWidget {
  final Estate estate;

  const ItemDetailBuy({Key? key, required this.estate, required latitude, required longitude}) : super(key: key);

  @override
  _ItemDetailBuyState createState() => _ItemDetailBuyState();
}

class _ItemDetailBuyState extends State<ItemDetailBuy> {
  int _current = 0;

  // Future<int> estimated() async {
  //   SalePredModel model = SalePredModel(
  //     size: widget.estate.size.toDouble(),
  //     numRooms: widget.estate.numRooms.toDouble(),
  //     numVerandas: widget.estate.numVerandas.toDouble(),
  //     numBathrooms: widget.estate.numBathrooms.toDouble(),
  //   );

  //   String predValue = await model.predData();
  //   double estimatedValue = double.parse(predValue);
  //   int estimatedIntValue = estimatedValue.round();
  //   return estimatedIntValue;
  // }

  late String mergedID = "";
  late bool isFavorite = false;
  late bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');

    if (sessionId != null) {
      List<String> parts = sessionId.split('.');
      mergedID = parts[1].toString() + "." + parts[2].toString();
      print('llllllllll' + mergedID);
    }
  }

  @override
  void initState() {
    super.initState();

    checkFavoriteStatus(widget.estate);
  }

  void checkFavoriteStatus(Estate estate) {
    fetchUserData();
    print("tttttt" + mergedID);
    final DatabaseReference watchlistRef =
        FirebaseDatabase.instance.reference().child('watchlist');
    watchlistRef.onValue.listen((event) {
      if (_isDisposed) return;
      if (event.snapshot.value != null) {
        final watchlistData = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        //print(watchlistData);
        bool isUserFavorite = watchlistData.entries.any((entry) =>
            entry.value['custUsername'] == mergedID &&
            entry.value['description'] == estate.description);

        setState(() {
          if (isUserFavorite) {
            isFavorite = true; // Set isFavorite to true conditionally
          } else if (!isUserFavorite) {
            // Handle the case when the user is not in the watchlist
            isFavorite = false;
          }
        });
      }
    });
  }

  void _saveWatchlist(Estate estate) {
    String apartmentOwnerId = estate.OwnerID;
    String apartmentcity = estate.city;
    DatabaseReference watchlistRef =
        FirebaseDatabase.instance.reference().child('watchlist');

    watchlistRef.push().set({
      'apartmentOwnerId': apartmentOwnerId,
      'apartmentcity': apartmentcity,
      'custUsername': mergedID,
      'images': estate.images,
      'type': estate.type,
      'description': estate.description,
      'price': estate.price,
      'numRooms': estate.numRooms,
      'numBathrooms': estate.numBathrooms,
      'size': estate.size,
      'address1': estate.address1,
    }).then((_) {
      _showSuccessDialog();
    }).catchError((error) {
      print('error');
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تمت الاضافة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.estate.images.map((imageUrl) {
        int index = widget.estate.images.indexOf(imageUrl);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == index ? Colors.white : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              height: 350.0,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: widget.estate.images.map((imageUrl) {
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              );
            }).toList(),
          ),
          Positioned(
            bottom: 498,
            left: 0,
            right: 0,
            child: _dotIndicator(),
          ),
          Positioned(
            top: -40,
            left: -60,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
          Positioned(
            top: 42,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite; // Toggle the icon's state
                  if (isFavorite) {
                    _saveWatchlist(widget.estate);
                  }
                });
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? primaryRed : primaryRed,
                size: 34,
              ),
            ),
          ),
          Positioned(
            top: 314,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                width: 315,
                height: 78,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 112, 112, 112).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const SignupScreen()),
                            // );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(80, 158, 158, 158),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.location_on_outlined),
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            // Do something when "عرض الخريطة" text is clicked
                          },
                          child: Text(
                            "عرض الخريطة",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
 Navigator.push(context,
      MaterialPageRoute(builder: (context) => NearByPlacesScreen(latitude:widget.estate.latitude,longitude:widget.estate.longitude)),
    );                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(80, 158, 158, 158),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.near_me),
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            // Do something when "قريب من" text is clicked
                          },
                          child: Text(
                            "قريب من",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactOwnerScreen(
                                    ownerID: widget.estate.OwnerID),
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(80, 158, 158, 158),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.contact_page_outlined),
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactOwnerScreen(
                                    ownerID: widget.estate.OwnerID),
                              ),
                            );
                          },
                          child: Text(
                            "تواصل",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 348,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 10,
                        decoration: BoxDecoration(
                          color: primaryRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.estate.type,
                        style: TextStyle(
                          fontFamily: 'Scheherazade_New',
                          color: primaryRed,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 8.0),
                  child: Text(
                    '${widget.estate.city}، ${widget.estate.address1}',
                    style: TextStyle(
                      fontFamily: 'Scheherazade_New',
                      color: Colors.black,
                      fontSize: 19,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 325,
            right: 0,
            left: null,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 0.0),
              child: Text(
                "\$" + widget.estate.price.toString(),
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  color: primaryRed,
                  fontSize: 22,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 297,
            right: 0,
            left: null,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 0.0),
              child: FutureBuilder<int>(
                // future: estimated(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return a loading indicator or placeholder text
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle the error state
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Display the predValue
                    final predValue = snapshot.data.toString();
                    return Text(
                      " \$السعر المخمن: $predValue",
                      style: TextStyle(
                        fontFamily: 'Scheherazade_New',
                        color: Color.fromARGB(255, 56, 86, 47),
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 266,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/icons/Red_bathroom.png'),
                        width: 20,
                        height: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.numBathrooms.toString(),
                        style: TextStyle(
                          fontFamily: 'Scheherazade_New',
                          color: primaryRed,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/icons/Red_bedroom.png'),
                        width: 20,
                        height: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.numRooms.toString(),
                        style: TextStyle(
                          fontFamily: 'Scheherazade_New',
                          color: primaryRed,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/icons/Red_balcony.png'),
                        width: 20,
                        height: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.numVerandas.toString(),
                        style: TextStyle(
                          fontFamily: 'Scheherazade_New',
                          color: primaryRed,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/icons/Red_size.png'),
                        width: 20,
                        height: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.size.toString(),
                        style: TextStyle(
                          fontFamily: 'Scheherazade_New',
                          color: primaryRed,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 220,
            right: 0,
            left: null,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 0.0),
              child: Text(
                "الوصف",
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  color: Colors.black,
                  fontSize: 22,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Positioned(
            top: 600, // adjust the top position as per your requirement
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0, bottom: 0.0),
              child: Text(
                widget.estate.description,
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  color: Colors.grey,
                  fontSize: 12,
                  decoration: TextDecoration.none,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 0,
            left: 0,
            child: Container(
              height: 60.0,
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReserveAppointment(
                          ownerID: widget.estate.OwnerID,
                          city: widget.estate.city);
                    },
                  );
                },
                child: Text(
                  'حجز موعد',
                  style: TextStyle(
                      fontFamily: 'Scheherazade_New',
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
