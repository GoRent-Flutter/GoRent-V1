import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../BuyList/buylist_screen.dart';
import '../RentList/rentlist_screen.dart';

class FiltersScreen extends StatefulWidget {
  final String selectedCity;
  final bool isRentSelected;
  final bool isBuySelected;
  final RangeValues priceRange;
  final RangeValues areaRange;
  final int selectedRooms;
  final int selectedBathrooms;
  final List<String> selected;
  final Function(
          String, bool, bool, RangeValues, RangeValues, int, int, List<String>)
      onFiltersApplied;

  FiltersScreen({
    required this.selectedCity,
    required this.isRentSelected,
    required this.isBuySelected,
    required this.priceRange,
    required this.areaRange,
    required this.selectedRooms,
    required this.selectedBathrooms,
    required this.onFiltersApplied,
    required this.selected,
  });

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FiltersScreen> {
  String _selectedCity = "";
  bool _isRentSelected = true;
  bool _isBuySelected = true;
  RangeValues _priceRange = const RangeValues(0, 200000);
  RangeValues _areaRange = const RangeValues(0, 200);
  int _selectedRooms = 0; // Initialize with 0
  int _selectedBathrooms = 0; // Initialize with 0
  List<String> availablePlaces = [
    'مدرسة',
    'روضة',
    'جامع',
    'سوبر ماركت',
    'مطعم',
    'حديقة',
    'مستشفى'
  ];
  List<String> selectedPlaces = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _isRentSelected = widget.isRentSelected;
    _isBuySelected = widget.isBuySelected;
    _priceRange = widget.priceRange;
    _areaRange = widget.areaRange;
    _selectedRooms = widget.selectedRooms;
    _selectedBathrooms = widget.selectedBathrooms;
    selectedPlaces = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryWhite,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: primaryRed,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'خاصية البحث',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'المدينة',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCity = "رام الله";
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedCity == "رام الله"
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedCity == "رام الله"
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'رام الله',
                              style: TextStyle(
                                color: _selectedCity == "رام الله"
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCity = "بيت لحم";
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedCity == "بيت لحم"
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedCity == "بيت لحم"
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'بيت لحم',
                              style: TextStyle(
                                color: _selectedCity == "بيت لحم"
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCity = "طولكرم";
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedCity == "طولكرم"
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedCity == "طولكرم"
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'طولكرم',
                              style: TextStyle(
                                color: _selectedCity == "طولكرم"
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCity = "نابلس";
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedCity == "نابلس"
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedCity == "نابلس"
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'نابلس',
                              style: TextStyle(
                                color: _selectedCity == "نابلس"
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'نوع العقار',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              CheckboxListTile(
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('إيجار'),
                ),
                value: _isRentSelected,
                onChanged: (value) {
                  setState(() {
                    _isRentSelected = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: primaryRed,
                checkColor: primaryWhite,
                tileColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
              CheckboxListTile(
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('شراء'),
                ),
                value: _isBuySelected,
                onChanged: (value) {
                  setState(() {
                    _isBuySelected = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: primaryRed,
                checkColor: primaryWhite,
                tileColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'نطاق السعر',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200000,
                divisions: 10,
                onChanged: (values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
                activeColor: primaryRed,
                inactiveColor: primaryRed.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الحد الأدنى: ${_priceRange.start.round()}'),
                    Text('الحد الأقصى: ${_priceRange.end.round()}'),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'نطاق المساحة',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              RangeSlider(
                values: _areaRange,
                min: 0,
                max: 200,
                divisions: 10,
                onChanged: (values) {
                  setState(() {
                    _areaRange = values;
                  });
                },
                activeColor: primaryRed,
                inactiveColor: primaryRed.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الحد الأدنى: ${_areaRange.start.round()} متر مربع'),
                    Text('الحد الأقصى: ${_areaRange.end.round()} متر مربع'),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  'عدد الغرف',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRooms = 1;
                            // print("_selectedRooms"+_selectedRooms.toString());
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color:
                                _selectedRooms == 1 ? Colors.white : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedRooms == 1
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: _selectedRooms == 1
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRooms = 2;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color:
                                _selectedRooms == 2 ? Colors.white : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedRooms == 2
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: _selectedRooms == 2
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRooms = 3;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color:
                                _selectedRooms == 3 ? Colors.white : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedRooms == 3
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: _selectedRooms == 3
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRooms = 4;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color:
                                _selectedRooms == 4 ? Colors.white : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedRooms == 4
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '4',
                              style: TextStyle(
                                color: _selectedRooms == 4
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  'عدد الحمامات',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBathrooms = 1;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedBathrooms == 1
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedBathrooms == 1
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: _selectedBathrooms == 1
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBathrooms = 2;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedBathrooms == 2
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedBathrooms == 2
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: _selectedBathrooms == 2
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBathrooms = 3;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedBathrooms == 3
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedBathrooms == 3
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: _selectedBathrooms == 3
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBathrooms = 4;
                          });
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: _selectedBathrooms == 4
                                ? Colors.white
                                : primaryRed,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: _selectedBathrooms == 4
                                  ? primaryRed
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '4',
                              style: TextStyle(
                                color: _selectedBathrooms == 4
                                    ? primaryRed
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Inside the build method of your Flutter widget
              // Define the available places list

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الاماكن المجاورة',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    buildDropdownField(),
                    SizedBox(height: 10),
                    buildSelectedPlaces(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        Map<String, dynamic> body = {
                          "numRooms": _selectedRooms,
                          "numBathrooms": _selectedBathrooms,
                          "size": [_areaRange.start, _areaRange.end],
                          "price": [_priceRange.start, _priceRange.end],
                          "type": [
                            if (_isBuySelected) "بيع",
                            if (_isRentSelected) "اجار",
                          ],
                        };

                        var response = await http.post(
                          Uri.parse('http://192.168.1.23:5000/recommend'),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(body),
                        );
                        
                        if (response.statusCode == 200 &&
                            !response.body.contains(
                                "No properties found matching the specified filters.")) {
                                  List<dynamic> responseBody = jsonDecode(response.body);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String rawJson = jsonEncode(responseBody);
                          prefs.setString('response', rawJson);
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                        prefs.remove("response");
                          print(
                              'Failed to send the request. Status code: ${response.statusCode}');
                        }

                        await Future.delayed(Duration(seconds: 3));
                        widget.onFiltersApplied(
                          _selectedCity.toString(),
                          _isRentSelected,
                          _isBuySelected,
                          _priceRange,
                          _areaRange,
                          _selectedRooms,
                          _selectedBathrooms,
                          selectedPlaces,
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        Navigator.pop(context, {
                          'selectedCity': _selectedCity.toString(),
                          'isRentSelected': _isRentSelected,
                          'isBuySelected': _isBuySelected,
                          'priceRange': _priceRange,
                          'areaRange': _areaRange,
                          'selectedRooms': _selectedRooms,
                          'selectedBathrooms': _selectedBathrooms,
                          'selectedPlaces': selectedPlaces,
                        });
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('تطبيق الفلاتر'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                      ),
                    )
                  ],
                ),
              ])
            ]))));
  }

  Widget buildDropdownField() {
    return DropdownButtonFormField<String>(
      items: availablePlaces.map((String place) {
        return DropdownMenuItem<String>(
          value: place,
          child: Text(place),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          if (value != null && !selectedPlaces.contains(value)) {
            selectedPlaces.add(value);
          }
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'اختر المكان',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryRed, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryRed, width: 2.0),
        ),
      ),
    );
  }

  Widget buildSelectedPlaces() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الاماكن المجاورة المختارة',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: primaryRed,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: selectedPlaces.map((String place) {
              return Chip(
                label: Text(place),
                deleteIconColor: primaryRed,
                backgroundColor: primaryWhite,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: primaryRed, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                deleteButtonTooltipMessage: 'حذف',
                onDeleted: () {
                  setState(() {
                    selectedPlaces.remove(place);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
