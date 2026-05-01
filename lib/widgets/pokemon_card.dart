import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp/models/pokemon.dart';
import 'package:pokeapp/providers/pokemon_data_providers.dart';
import 'package:pokeapp/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(
      favoritePokemonsProvider.notifier,
    );
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
      data: (data) => _card(context, data, false),
      error: (error, stackTrace) =>
          Text('Error while loading Pokemon card: $error'),
      loading: () => _card(context, null, true),
    );
  }

  Widget _card(BuildContext context, Pokemon? pokemon, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (context) => PokemonStatsCard(pokemonUrl: pokemonUrl)
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? 'Pokemon',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '#${pokemon?.id.toString() ?? '0'}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  backgroundImage: pokemon != null
                      ? NetworkImage(pokemon.sprites!.frontDefault!)
                      : null,
                  backgroundColor: Colors.transparent,
                  radius: MediaQuery.sizeOf(context).height * 0.05,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${pokemon?.moves?.length ?? '0'} moves',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemonsProvider.removeFavoritePokemon(pokemonUrl);
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
