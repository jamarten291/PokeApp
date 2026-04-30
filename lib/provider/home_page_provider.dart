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
    _httpService = _getIt.get<HTTPService>();
    _setup();
  }

  Future<void> _setup() async {
    _loadData();
  }

  Future<void> _loadData() async {
    if (state.data == null) {
      Response? res = await _httpService.get(
        'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0'
      );
      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(
          data: data
        );
        print(state.data?.results?.first);
      }
    } else {

    }
  }
}