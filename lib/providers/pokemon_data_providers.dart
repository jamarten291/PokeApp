import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/models/pokemon.dart';
import 'package:pokeapp/services/database_service.dart';
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
final favoritePokemonsProvider = StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider([]);
});

// StateNotifier that stores a list of strings, which are references to the
// favorite Pokemons
class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  String FAVORITE_POKEMONS_LIST_KEY = "FAVORITE_POKEMONS";

  FavoritePokemonsProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? favoritePokemonData = await _databaseService.loadList(
        FAVORITE_POKEMONS_LIST_KEY,
    );
    state = favoritePokemonData ?? [];
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _databaseService.persistList(FAVORITE_POKEMONS_LIST_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.persistList(FAVORITE_POKEMONS_LIST_KEY, state);
  }
}