import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokeapp/models/page_data.dart';
import 'package:pokeapp/models/pokemon.dart';
import 'package:pokeapp/controllers/home_page_controller.dart';
import 'package:pokeapp/providers/pokemon_data_providers.dart';
import 'package:pokeapp/widgets/pokemon_card.dart';
import 'package:pokeapp/widgets/pokemon_list_tile.dart';

// Provider that uses the HomePageController to get the data.
final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
      return HomePageController(HomePageData.initial());
    });

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 0.9 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('PokeApp')),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemonsList(context),
              _allPokemonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favorites', style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: _favoritePokemons.isEmpty
                ? const Center(
                    child: Text("No favorite Pokemons yet! :("),
                  )
                : GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: _favoritePokemons.length,
                    itemBuilder: (context, index) {
                      String pokemonUrl = _favoritePokemons[index];
                      return PokemonCard(pokemonUrl: pokemonUrl);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Pokemons', style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            child: ListView.builder(
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult currentPokemon =
                    _homePageData.data!.results![index];
                String pokemonUrl = currentPokemon.url ?? '';
                // Pass the pokemon url to the PokemonListTile widget.
                return PokemonListTile(pokemonUrl: pokemonUrl);
              },
            ),
          ),
        ],
      ),
    );
  }
}
