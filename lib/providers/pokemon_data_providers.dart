import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/models/pokemon.dart';
import 'package:pokeapp/services/http_service.dart';

// Provider that gets the pokemon data from the api using the url.
final pokemonDataProvider =
  FutureProvider.family<Pokemon?, String>((ref, url) async {
    HTTPService httpService = GetIt.instance.get<HTTPService>();
    Response? res = await httpService.get(url);
    if (res != null && res.data != null) {
      return Pokemon.fromJson(res.data);
    }
    return null;
  });

// Provider that gets the favorite pokemon data initialized with an empty list
final favoritePokemonsProvider = StateNotifierProvider((ref) {
  return FavoritePokemonsProvider([]);
});

// StateNotifier that stores a list of strings, which are references to the
// favorite Pokemons
class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  FavoritePokemonsProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {}
}