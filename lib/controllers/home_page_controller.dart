import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/models/page_data.dart';
import 'package:pokeapp/models/pokemon.dart';

import '../services/http_service.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;

  late final HTTPService _httpService;

  HomePageController(super.state) {
    // Get the http service from the get it container.
    _httpService = _getIt.get<HTTPService>();
    _setup();
  }

  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      // Get the data from the api.
      Response? res = await _httpService.get(
        'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0'
      );
      if (res != null && res.data != null) {
        // If the data is not null, update the state of the controller.
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(
          data: data
        );
      }
    } else {
      if (state.data?.next != null) {
        Response? res = await _httpService.get(
            state.data!.next!,
        );
        if (res != null && res.data != null) {
          PokemonListData data = PokemonListData.fromJson(res.data);
          state = state.copyWith(
            data: data.copyWith(
              results: [
                ...?state.data?.results,
                ...?data.results,
              ],
            ),
          );
        }
      }
    }
  }
}