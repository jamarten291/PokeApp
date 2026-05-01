import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  DatabaseService();

  Future<bool?> persistList(String key, List<String> value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setStringList(key, value);
      return result;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<String>?> loadList(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? result = prefs.getStringList(key);
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }
}