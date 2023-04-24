import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/BuyList/card.dart';
import '../Filters/filters.dart';
import '../Main/main_screen.dart';

class Estate {
  final String image;
  final String title;
  final String type;
  final String price;
  final String bedrooms;
  final String bathrooms;
  final String space;

  Estate(
      {required this.image,
      required this.title,
      required this.type,
      required this.price,
      required this.bedrooms,
      required this.bathrooms,
      required this.space});
}

class BuyListScreen extends StatelessWidget {
  final List<Estate> _estates = [
    Estate(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 1',
        type: 'شقة للشراء',
        price: '\$400/m',
        bedrooms: '2',
        bathrooms: '2',
        space: '1400 Ft'),
    Estate(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 2',
        type: 'بيت للشراء',
        price: '\$300/m',
        bedrooms: '3',
        bathrooms: '1',
        space: '1040 Ft'),
    Estate(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 3',
        type: 'بيت للشراء',
        price: '\$500/m',
        bedrooms: '3',
        bathrooms: '1',
        space: '1040 Ft'),
    Estate(
        image: 'assets/images/apartments.jpg',
        title: 'العقار 4',
        type: 'شقة للشراء',
        price: '\$600/m',
        bedrooms: '3',
        bathrooms: '2',
        space: '1800 Ft'),
  ];

  BuyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            // width: 100,
            // height: 100,
            child: SizedBox(
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
            top: 180,
            left: 20,
            right: 20,
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.75,
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
                      "العقارات المتاحة للشراء",
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 35, // or any other suitable value
                  left: 10,
                  right: 10, // or any other suitable value
                  child: SizedBox(
                    height: size.height - 250,
                    width: size.width -
                        40, // subtract the left and right padding from the total width
                    child: ListView.builder(
                      itemCount: _estates.length,
                      itemBuilder: (context, index) {
                        final estate = _estates[index];

                        return MyCard(
                          estate: estate,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 310,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: primaryWhite,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: AssetImage(estate.image),
                                          fit: BoxFit.cover,
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
                                      estate.price,
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
                                      estate.title,
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
                                        padding: EdgeInsets.only(left: 6.0),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/Red_bedroom.png'),
                                          width: 20,
                                          height: 18,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // add some spacing between the icon and text

                                      Padding(
                                        padding: EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          estate.bedrooms,
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
                                      SizedBox(
                                          width:
                                              5), // add some spacing between the icon and text

                                      Padding(
                                        padding: EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          estate.bathrooms,
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
                                      SizedBox(
                                          width:
                                              5), // add some spacing between the icon and text

                                      Padding(
                                        padding: EdgeInsets.only(right: 75.0),
                                        child: Text(
                                          estate.space,
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
                                      estate.type,
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
          Positioned(
            top: size.width - size.width + 120,
            left: 10,
            child: Container(
              height: 50,
              width: size.width - 100,
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Material(
                color: Colors.transparent,
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: InputBorder.none,
                    hintText: 'ابحث',
                    hintTextDirection: TextDirection.rtl,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.width - size.width + 124,
            left: size.width - 78,
            right: 20,
            child: Container(
              height: size.width - 343,
              width: 20,
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: GestureDetector(
                child: Stack(
                  children: [
                    Positioned(
                      top: 3,
                      left: 3,
                      right: 3,
                      bottom: 3,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Image.asset('assets/icons/Grey_filters.png'),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const FiltersScreen(),
                  ));
                },
              ),
            ),
          ),
        ]))));
  }
}
