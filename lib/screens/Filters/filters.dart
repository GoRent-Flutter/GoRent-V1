import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';

import '../BuyList/buylist_screen.dart';
import '../RentList/rentlist_screen.dart';

class FiltersScreen extends StatefulWidget {
  final bool isRentSelected;
  final bool isBuySelected;
  final RangeValues priceRange;
  final RangeValues areaRange;
  final int selectedRooms;
  final int selectedBathrooms;
  final Function(bool, bool, RangeValues, RangeValues, int, int)
      onFiltersApplied;

  FiltersScreen({
    required this.isRentSelected,
    required this.isBuySelected,
    required this.priceRange,
    required this.areaRange,
    required this.selectedRooms,
    required this.selectedBathrooms,
    required this.onFiltersApplied,
  });

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FiltersScreen> {
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
    _isRentSelected = widget.isRentSelected;
    _isBuySelected = widget.isBuySelected;
    _priceRange = widget.priceRange;
    _areaRange = widget.areaRange;
    _selectedRooms = widget.selectedRooms;
    _selectedBathrooms = widget.selectedBathrooms;
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
                  'نوع العقار',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('إيجار'),
                      Checkbox(
                        value: _isRentSelected,
                        onChanged: (value) {
                          setState(() {
                            _isRentSelected = value!;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return primaryRed;
                            }
                            return primaryWhite; // White color when checkbox is unselected
                          },
                        ),
                        checkColor:
                            primaryWhite, // White color for the check mark
                      ),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                dense: true,
                visualDensity: VisualDensity.compact,
                tileColor: Colors.transparent,
              ),
              ListTile(
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('شراء'),
                      Checkbox(
                        value: _isBuySelected,
                        onChanged: (value) {
                          setState(() {
                            _isBuySelected = value!;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return primaryRed; // Red color when checkbox is selected
                            }
                            return primaryWhite; // White color when checkbox is unselected
                          },
                        ),
                        checkColor:
                            primaryWhite, // White color for the check mark
                      ),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                dense: true,
                visualDensity: VisualDensity.compact,
                tileColor: Colors.transparent,
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
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    'الاماكن المجاورة',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                    ),
                    textDirection: TextDirection.rtl,
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

                        await Future.delayed(Duration(seconds: 3));
                        widget.onFiltersApplied(
                          _isRentSelected,
                          _isBuySelected,
                          _priceRange,
                          _areaRange,
                          _selectedRooms,
                          _selectedBathrooms,
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        Navigator.pop(context, {
                          'isRentSelected': _isRentSelected,
                          'isBuySelected': _isBuySelected,
                          'priceRange': _priceRange,
                          'areaRange': _areaRange,
                          'selectedRooms': _selectedRooms,
                          'selectedBathrooms': _selectedBathrooms,
                        });
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('تطبيق الفلاتر'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                      ),
                    ),
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
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              'الاماكن المجاورة المختارة:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
              textDirection: TextDirection.rtl,
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
