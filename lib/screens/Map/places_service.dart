import 'package:dio/dio.dart';

import '../../constraints.dart';

class PlacesService {
  late Dio dio;
  PlacesService() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 20 * 1000),
      receiveTimeout: const Duration(seconds: 20 * 1000),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getSuggestedPlaces(
      String place, String sessionToken) async {
    try {
      Response response = await dio.get(suggested_places, queryParameters: {
        'input': place,
        'type': 'address',
        'components': 'country:il',
        'key': placesApi_Key,
        'sessionToken': sessionToken
      });
      return response.data['predictions'];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}
