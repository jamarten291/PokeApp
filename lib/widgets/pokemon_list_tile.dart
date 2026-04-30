import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp/models/pokemon.dart';
import 'package:pokeapp/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonListTile({
    super.key,
    required this.pokemonUrl
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the pokemon data from the provider.
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    // Handle the different states of the pokemon data.
    return pokemon.when(
      data: (data) => _tile(context, data, false),
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => _tile(context, null, true),
    );
  }

  Widget _tile(BuildContext context, Pokemon? pokemon, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        // If the pokemon is not null, show the pokemon image.
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  pokemon.sprites!.frontDefault!,
                ),
              )
            : CircleAvatar(),
        title: Text(
          // If the pokemon is null, return an empty string.
          pokemon?.name!.toUpperCase()
              ?? 'Currently loading name for Pokemon.',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          "Has ${pokemon?.moves?.length.toString() ?? '0'} moves."
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_border,
          ),
        ),
      ),
    );
  }
}
