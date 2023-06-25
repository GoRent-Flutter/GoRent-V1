// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';


// class EditApartmentScreen extends StatefulWidget {
//   final apartment apartment;
//   final String ownerId;

//   EditApartmentScreen({required this.apartment, required this.ownerId});

//   @override
//   _EditApartmentScreenState createState() => _EditApartmentScreenState();
// }


// class _EditApartmentScreenState extends State<EditApartmentScreen> {
//   late DatabaseReference _databaseRef;
//   String editedCity = '';
//   String editedType = '';
//   int editedPrice = 0;

//   @override
//   void initState() {
//     super.initState();
//     _databaseRef = FirebaseDatabase.instance.reference();
//     editedCity = widget.apartment.city;
//     editedType = widget.apartment.type;
//     editedPrice = widget.apartment.price;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Apartment'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextFormField(
//               initialValue: editedCity,
//               onChanged: (value) {
//                 setState(() {
//                   editedCity = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'City',
//               ),
//             ),
//             TextFormField(
//               initialValue: editedType,
//               onChanged: (value) {
//                 setState(() {
//                   editedType = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Type',
//               ),
//             ),
//             TextFormField(
//               initialValue: editedPrice.toString(),
//               onChanged: (value) {
//                 setState(() {
//                   editedPrice = int.tryParse(value) ?? 0;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Price',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Save the changes to Firebase
//                 _saveChanges();
//               },
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _saveChanges() {
//     if (widget.apartment is MyApartment) {
//       _databaseRef.child('rent').child(editedCity).set({
//         'OwnerID': widget.ownerId,
//         'city': editedCity,
//         'type': editedType,
//         'price': editedPrice,
//       });
//     } else if (widget.apartment is MyApartment2) {
//       _databaseRef.child('sale').child(editedCity).set({
//         'OwnerID': widget.ownerId,
//         'city': editedCity,
//         'type': editedType,
//         'price': editedPrice,
//       });
//     }

//     Navigator.pop(context);
//   }
// }
