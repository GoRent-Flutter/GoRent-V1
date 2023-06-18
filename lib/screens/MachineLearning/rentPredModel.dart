// import 'package:tflite_flutter/tflite_flutter.dart';

// //this is only for sale predection model.
// class RentPredModel {
//   late double size;
//   late double numRooms;
//   late double numBathrooms;

//   RentPredModel(
//       {required this.size,
//       required this.numRooms,
//       required this.numBathrooms});

//   Future<String> predData() async {
//     late String predValue;
//     final interpreter =
//         await Interpreter.fromAsset('machine_learning_models/ForRent_ML_neural_model.tflite');
//     var input = [
//       [size, numRooms, numBathrooms]
//     ];
//     var output = List.filled(1, 0).reshape([1, 1]);
//     interpreter.run(input, output);
//     print(output[0][0]);
//     predValue = output[0][0].toString();
//     return predValue;
//   }
// }
