import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../BuyList/buylist_screen.dart';
import '../RentList/rentlist_screen.dart';
import '../SignUp/signup_screen.dart';
import '../../constraints.dart';

class CircleIndicator extends StatelessWidget {
  final int count;
  final int current;

  CircleIndicator({
    required this.count,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int i = 0; i < count; i++) {
      children.add(
        Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: current == i
                ? Colors.white.withOpacity(0.6)
                : Colors.grey.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class ItemDetailBuy extends StatefulWidget {
  final Estate estate;

  const ItemDetailBuy({Key? key, required this.estate}) : super(key: key);

  @override
  _ItemDetailBuyState createState() => _ItemDetailBuyState();
}

class _ItemDetailBuyState extends State<ItemDetailBuy> {
  int _current = 0;

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
            items: [
              Image.asset(
                widget.estate.image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Image.asset(
                'assets/images/apartmentBethlehem.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Image.asset(
                'assets/images/AB2.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ],
          ),
          Positioned(
            top: -40,
            left: -60,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RentListScreen()),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RentListScreen()),
                );
              },
              child: Icon(
                Icons.favorite_border_outlined,
                color: primaryRed,
                size: 34,
              ),
            ),
          ),
          Positioned(
            bottom: 505,
            left: 0,
            right: 0,
            child: CircleIndicator(
              count: 3,
              current: _current,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                            );
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
                            // Do something when contact icon is clicked
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
                    widget.estate.title,
                    style: TextStyle(
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
                "\$114,600",
                style: TextStyle(
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
              child: Text(
                "\$السعر المخمن : 113,400",
                style: TextStyle(
                  color: Color.fromARGB(255, 56, 86, 47),
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
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
                      Icon(Icons.bathtub_outlined, color: primaryRed, size: 25),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.bathrooms,
                        style: TextStyle(
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
                      Icon(Icons.bed_rounded, color: primaryRed, size: 25),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.bedrooms,
                        style: TextStyle(
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
                      Icon(Icons.square_foot_outlined,
                          color: primaryRed, size: 25),
                      SizedBox(width: 5),
                      Text(
                        widget.estate.space,
                        style: TextStyle(
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
                  color: Colors.black,
                  fontSize: 22,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 180,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0, bottom: 0.0),
              child: Text(
                ".شقة مفروشة بالكامل في بيت لحم سنتر ، تقع في بيت لحم ، مع شرفة ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  decoration: TextDecoration.none,
                ),
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
                  // Handle button press here
                },
                child: Text(
                  'حجز موعد',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
