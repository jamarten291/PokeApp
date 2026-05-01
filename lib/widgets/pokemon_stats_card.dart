import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonUrl;
  const PokemonStatsCard({
    super.key,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return AlertDialog(
      title: Text('Statistics'),
      content: pokemon.when(
          data: (data) => Column(
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((data) {
              return Text(
                '${data.stat?.name?.toUpperCase()}: ${data.baseStat}'
              );
            }).toList() ?? [],
          ),
          error: (error, stackTrace) => Text('Error while loading Pokemon stats: $error'),
          loading: () => const CircularProgressIndicator(color: Colors.white,)
      ),
    );
  }
}