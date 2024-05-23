import 'package:shared_preferences/shared_preferences.dart';

class TipsManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const String _keyFavorites = 'tipFavorites';

  static Future<bool> saveFavoriteTips(List<int> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(
        _keyFavorites, favorites.map((e) => e.toString()).toList());
  }

  static Future<List<int>> loadFavoriteTips() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList(_keyFavorites);
    return favorites?.map(int.parse).toList() ?? [];
  }
}
