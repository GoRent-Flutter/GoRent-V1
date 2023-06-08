import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_customer.dart';
import '../../guest_bottom_nav.dart';
import '../../owner_bottom_nav_bar.dart';
import '../../user_bottom_nav_bar.dart';
import '../BuyList/buylist_screen.dart';
import '../BuyList/card.dart';
import '../Filters/filters.dart';
import '../RentList/rentlist_screen.dart';
import 'Search/search_screen.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;
  // final String userSessionId;
  const MainScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool isPopular = true;
  bool isNewlyAdded = false;
  bool isRecommended = false;
  // bool isGuest = true; // Add this variable to track if the user is a guest

  // @override
  // void initState() {
  //   checkUserType(); // Check if the user is a guest when the screen initializes
  // }

  // void checkUserType() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? sessionId = prefs.getString('sessionId');
  //   if (sessionId != null && sessionId.contains("-GRCU")) {
  //     setState(() {
  //       isGuest = false;
  //     });
  //   }
  // }

  final List<Estate> _estates = [
    Estate(
        images: ['assets/images/apartments.jpg'],
        city: 'العقار 1',
        type: 'شقة للشراء',
        description: 'test',
        price: 400,
        numRooms: 2,
        numBathrooms: 2,
        size: 1400,
        numVerandas: 0,
        OwnerID: 'test'),
    Estate(
        images: ['assets/images/apartments.jpg'],
        city: 'العقار 2',
        type: 'بيت للشراء',
        description: 'test',
        price: 300,
        numRooms: 3,
        numBathrooms: 1,
        size: 1040,
        numVerandas: 0,
        OwnerID: 'tst1'),
    Estate(
        images: ['assets/images/apartments.jpg'],
        city: 'العقار 3',
        type: 'بيت للشراء',
        description: 'test',
        price: 500,
        numRooms: 3,
        numBathrooms: 1,
        size: 1040,
        numVerandas: 0,
        OwnerID: 'tst3'),
    Estate(
        images: ['assets/images/apartments.jpg'],
        city: 'العقار 4',
        type: 'شقة للشراء',
        description: 'test',
        price: 600,
        numRooms: 3,
        numBathrooms: 2,
        size: 1800,
        numVerandas: 0,
        OwnerID: 'tst3'),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentIndex = widget.currentIndex;
    return Container(
      color: Colors.transparent,
      child: SizedBox(
        child: Stack(children: <Widget>[
          Positioned(
              child: Scaffold(
            bottomNavigationBar: currentIndex == 1
                ? const BottomNavBar(
                    currentIndex: 0,
                  )
                : currentIndex == 0
                    ? const OwnerBottomNavBar(
                        currentIndex: 1,
                      )
                    : const GuestBottomNavBar(
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
                        child: Icon(Icons.message, color: primaryRed,),
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
                        scale: 1.0,
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
                                fontFamily: 'Scheherazade_New',
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
                    builder: (BuildContext context) =>
                        BuyListScreen(currentIndex: widget.currentIndex),
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
                        scale: 1.0,
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
                                fontFamily: 'Scheherazade_New',
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
                      builder: (BuildContext context) => RentListScreen(
                            currentIndex: widget.currentIndex,
                          )));
                },
              ),
            ),
          ),
          Positioned(
              top: size.height - 390,
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
                              fontFamily: 'Scheherazade_New',
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
                              fontFamily: 'Scheherazade_New',
                              decoration: TextDecoration.none,
                              fontSize: 17,
                              color: isRecommended ? primaryLine : primaryRed),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          height: 1,
                          width: 71,
                          color:
                              isRecommended ? primaryLine : Colors.transparent,
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
                              fontFamily: 'Scheherazade_New',
                              decoration: TextDecoration.none,
                              fontSize: 17,
                              color: isNewlyAdded ? primaryLine : primaryRed),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          height: 1,
                          width: 71,
                          color:
                              isNewlyAdded ? primaryLine : Colors.transparent,
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
                                          image: AssetImage(
                                              'assets/images/apartments.jpg'),
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
                                      estate.price.toString(),
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
                                      estate.city,
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
                                          estate.numRooms.toString(),
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
                                          estate.numBathrooms.toString(),
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
                                          estate.size.toString(),
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
                  child: currentIndex == 2
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WelcomeScreenCustomer()),
                            );
                          },
                          child: Column(
                            children: [
                              const Text(
                                'Please click here to sign up to view this feature',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryRed,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: size.width / 5,
                                width: size.width / 2,
                                color:
                                    primaryRed, // Change the color to your desired color
                              ),
                            ],
                          ),
                        )
                      : const Text(
                          'Not available yet',
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryRed,
                            decoration: TextDecoration.none,
                          ),
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
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                currentIndex: widget.currentIndex,
                              )),
                    );
                  },
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
                    enabled: false,
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
