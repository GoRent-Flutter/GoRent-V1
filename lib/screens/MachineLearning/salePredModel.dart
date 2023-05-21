import 'package:tflite_flutter/tflite_flutter.dart';

//this is only for sale predection model.
class SalePredModel {
  late double size;
  late double numRooms;
  late double numVerandas;
  late double numBathrooms;

  SalePredModel(
      {required this.size,
      required this.numRooms,
      required this.numVerandas,
      required this.numBathrooms});

  Future<String> predData() async {
    late String predValue;
    final interpreter =
        await Interpreter.fromAsset('machine_learning_models/ForSale_ML_neural_model.tflite');
    var input = [
      [size, numRooms, numVerandas, numBathrooms]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);
    predValue = output[0][0].toString();
    return predValue;
  }
}
