import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('All Pokemons'),
      ),
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

              ],
            ),
          ),
        )
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Pokemons',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return ListTile();
              }
            ),
          )
        ]
      ),
    );
  }
}
