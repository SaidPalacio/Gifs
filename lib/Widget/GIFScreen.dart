import 'package:class_7_02/Models/Gifs.dart';
import 'package:flutter/material.dart';

import '../Provider/Gif.dart';

class GifScreen extends StatefulWidget {
  const GifScreen({Key? key}) : super(key: key);

  @override
  State<GifScreen> createState() => _GifScreenState();
}

class _GifScreenState extends State<GifScreen> {
  late Future<List<ModeloGif>> _gifs;
  late ScrollController _scrollController;
  List<ModeloGif> _allGifs = [];

  @override
  void initState() {
    super.initState();
    final gifprovider = GifProvider();
    _gifs = gifprovider.fetchGifs();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Cuando el usuario llega al final de la lista, cargamos más gifs
      _fetchMoreGifs();
    }
  }

  void _fetchMoreGifs() async {
    final gifProvider = GifProvider();
    final moreGifs = await gifProvider.fetchGifs();
    setState(() {
      _allGifs.addAll(moreGifs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('App Gifs'),
        ),
        body: FutureBuilder(
          future: _gifs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              List<ModeloGif>? data = snapshot.data;
              _allGifs.addAll(data!);

              return GridView.builder(
                controller: _scrollController,
                itemCount: _allGifs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  var rutaimg = _allGifs[index].images!.downsized!.url;

                  return Center(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(rutaimg.toString()),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text("Paso algo");
            }
          },
        ),
        //buildGridView(context),
      ),
    );
  }

  GridView buildGridView(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(100, (index) {
        return Center(
          child: Text(
            'Gif $index',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        );
      }),
    );
  }
}
