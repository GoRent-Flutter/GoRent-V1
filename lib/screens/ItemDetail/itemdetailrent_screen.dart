import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../ContactOwner/contact_owner.dart';
import '../MachineLearning/rentPredModel.dart';
import '../Map/map_screen.dart';
import '../RentList/rentlist_screen.dart';

import '../../constraints.dart';
import '../ReserveAppointment/reserveappointment_screen.dart';

class ItemDetail extends StatefulWidget {
  final Post post;

  const ItemDetail({Key? key, required this.post}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  int _current = 0;
  Future<int> estimated() async {
    RentPredModel model = RentPredModel(
      size: widget.post.size.toDouble(),
      numRooms: widget.post.numRooms.toDouble(),
      numBathrooms: widget.post.numBathrooms.toDouble(),
    );

    String predValue = await model.predData();
    double estimatedValue = double.parse(predValue);
    int estimatedIntValue = estimatedValue.round();
    return estimatedIntValue;
  }

  Widget _dotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.post.images.map((imageUrl) {
        int index = widget.post.images.indexOf(imageUrl);
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
            items: widget.post.images.map((imageUrl) {
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
                Navigator.pop(context);
              },
              child: Icon(
                Icons.favorite_border_outlined,
                color: primaryRed,
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const MapScreen()),
                            // );
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
                            // Do something when near me icon is clicked
                          },
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
                                  builder: (context) =>
                                      const ContactOwnerScreen()),
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
                            // Do something when "تواصل" text is clicked
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
                        'للايجار',
                        style: TextStyle(
                           fontFamily: 'Scheherazade_New',
                          color: primaryRed,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 8.0),
                  child: Text(
                    widget.post.city,
                    style: TextStyle(
                       fontFamily: 'Scheherazade_New',
                      color: Colors.black,
                      fontSize: 30,
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
                "\$" + widget.post.price.toString(),
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
                future: estimated(),
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
                      "\$السعر المخمن: $predValue",
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
                        widget.post.numBathrooms.toString(),
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
                        widget.post.numRooms.toString(),
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
                      Text(
                        widget.post.size.toString(),
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
                widget.post.description,
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
                      return ReserveAppointment();
                    },
                  );
                },
                child: Text(
                  'حجز موعد',
                  style: TextStyle( fontFamily: 'Scheherazade_New',color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
