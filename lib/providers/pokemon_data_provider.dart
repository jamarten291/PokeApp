import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
