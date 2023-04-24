import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import '../../user_bottom_nav_bar.dart';
import '../BuyList/buylist_screen.dart';
import '../BuyList/card.dart';
import '../Filters/filters.dart';
import '../RentList/rentlist_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool isPopular = true;
  bool isNewlyAdded = false;
  bool isRecommended = false;
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: SizedBox(
          child: Stack(children: <Widget>[
        const Positioned(
            child: Scaffold(
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
          ),
        )),
        Positioned(
            // top: -10,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: 1.08,
              child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
            )),
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
        Positioned(
          top: 200,
          left: 25,
          right: 207,
          child: Container(
            height: 177,
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
            child: GestureDetector(
              child: Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: 5,
                    right: 5,
                    bottom: 30,
                    child: Transform.scale(
                      scale: 0.9,
                      child: Image.asset('assets/icons/buy.png'),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            "شراء عقار",
                            style: TextStyle(
                              fontSize: 17,
                              color: primaryRed,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => BuyListScreen(),
                ));
              },
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: 207,
          right: 25,
          child: Container(
            height: 177,
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
            child: GestureDetector(
              child: Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: 5,
                    right: 5,
                    bottom: 30,
                    child: Transform.scale(
                      scale: 0.9,
                      child: Image.asset('assets/icons/rent.png'),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            "استئجار عقار",
                            style: TextStyle(
                              fontSize: 17,
                              color: primaryRed,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => RentListScreen(),
                ));
              },
            ),
          ),
        ),
        Positioned(
            top: size.height - 380,
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopular = true;
                      isNewlyAdded = false;
                      isRecommended = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "رائج",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: isPopular ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 71,
                        color: isPopular ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopular = false;
                      isNewlyAdded = false;
                      isRecommended = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "موصى به",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: isRecommended ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 71,
                        color: isRecommended ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopular = false;
                      isNewlyAdded = true;
                      isRecommended = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "مضاف حديثا",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: isNewlyAdded ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 71,
                        color: isNewlyAdded ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                )
              ],
            )),
        isPopular
            ? Positioned(
                top: size.height - 330,
                left: 30,
                right: 30,
                child: SizedBox(
                  height: size.height - 560,
                  width: size.width - 40,
                  child: ListView.separated(
                    //space between cards
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 30.0);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _estates.length,
                    itemBuilder: (context, index) {
                      final estate = _estates[index];

                      return MyCard(
                        estate: estate,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 7, left: 7, right: 7),
                              child: Stack(
                                children: [
                                  Container(
                                    width: size.width - 80,
                                    height: size.height - 660,
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
                                      image: DecorationImage(
                                        image: AssetImage(estate.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
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
                                  padding: EdgeInsets.only(
                                      top: 8,
                                      left: 13.0,
                                      right: size.width - 200),
                                  child: Text(
                                    estate.price,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: primaryRed,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 13.0),
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
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // set alignment
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6.0),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/Red_bedroom.png'),
                                        width: 20,
                                        height: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // add some spacing between the icon and text

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Text(
                                        estate.bedrooms,
                                        style: const TextStyle(
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
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6.0),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/Red_bathroom.png'),
                                        width: 20,
                                        height: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // add some spacing between the icon and text

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 13.0),
                                      child: Text(
                                        estate.bathrooms,
                                        style: const TextStyle(
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
                                    const Padding(
                                      padding: EdgeInsets.only(left: 0.0),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/Red_size.png'),
                                        width: 20,
                                        height: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // add some spacing between the icon and text

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 75.0),
                                      child: Text(
                                        estate.space,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: primaryRed,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13.0),
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
              )
            : Positioned(
                top: size.height - 330,
                left: 30,
                right: 30,
                child: const Text("not available yet",
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryRed,
                      decoration: TextDecoration.none,
                    )),
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
        )
      ])),
    );
  }
}
