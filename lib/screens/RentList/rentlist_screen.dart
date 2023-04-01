import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ItemDetail/itemdetailrent_screen.dart';
import 'package:gorent_application1/screens/RentList/square.dart';

import '../Main/main_screen.dart';

class Post {
  final String image;
  final String title;
  final String type;
  final String price;
  final String bedrooms;
  final String bathrooms;
  final String space;

  Post(
      {required this.image,
      required this.title,
      required this.type,
      required this.price,
      required this.bedrooms,
      required this.bathrooms,
      required this.space});
}

class RentListScreen extends StatelessWidget {
  final List<Post> _posts = [
    Post(
        image: 'assets/images/AB1.jpg',
        title: 'العقار 1',
        type: 'شقة للايجار',
        price: '\$400/m',
        bedrooms: '2',
        bathrooms: '2',
        space: '1400 Ft'),
    Post(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 2',
        type: 'بيت للايجار',
        price: '\$300/m',
        bedrooms: '3',
        bathrooms: '1',
        space: '1040 Ft'),
    Post(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 3',
        type: 'بيت للايجار',
        price: '\$500/m',
        bedrooms: '3',
        bathrooms: '1',
        space: '1040 Ft'),
    Post(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 4',
        type: 'شقة للايجار',
        price: '\$600/m',
        bedrooms: '3',
        bathrooms: '2',
        space: '1800 Ft'),
  ];

  RentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            // width: 100,
            // height: 100,
            child: Stack(children: <Widget>[
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
              )),
          Positioned(
            top: -40,
            left: -60,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -22,
            right: 10,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.white.withOpacity(0.33),
                  ),
                ],
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "ابحث",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: Stack(
              children: [
                Container(
                  height: size.height*0.68,
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: const Text(
                      "العقارات المتاحة للايجار",
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30, // or any other suitable value
                  left: 10,
                  right: 10, // or any other suitable value
                  child: SizedBox(
                    height: 500,
                    width: size.width -
                        40, // subtract the left and right padding from the total width
                    child: ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return MySquare(
                          post: post,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 310,
                                      height: 150,
                                      child: Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 4 / 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Material(
                                              child: Ink.image(
                                                image: AssetImage(post.image),
                                                fit: BoxFit.cover,
                                                child: InkWell(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemDetail(
                                                        post: post,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Icon(Icons.favorite_border,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // set alignment
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 13.0),
                                    child: Text(
                                      post.price,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // set alignment
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 14.0),
                                        child: Icon(
                                          Icons.bed_rounded,
                                          color: primaryRed,
                                          size: 16,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // add some spacing between the icon and text

                                      Padding(
                                        padding: EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          post.bedrooms,
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
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Icon(
                                          Icons.bathtub_outlined,
                                          color: primaryRed,
                                          size: 16,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // add some spacing between the icon and text

                                      Padding(
                                        padding: EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          post.bathrooms,
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
                                        child: Icon(
                                          Icons.square_foot_outlined,
                                          color: primaryRed,
                                          size: 16,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // add some spacing between the icon and text

                                      Padding(
                                        padding: EdgeInsets.only(right: 75.0),
                                        child: Text(
                                          post.space,
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
                                      post.type,
                                      style: const TextStyle(
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
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ])));
  }
}
