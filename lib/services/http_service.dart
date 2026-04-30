import 'package:dio/dio.dart';

class HTTPService {
  HTTPService();

  final _dio = Dio();

  // Method that gets data from a given path and returns a possible response.
  Future<Response?> get (String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (e) {
      print(e);
    }

    return null;
  }
}