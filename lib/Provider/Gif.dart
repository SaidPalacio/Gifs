import 'dart:convert';
import 'package:class_7_02/Models/Gifs.dart';
import 'package:http/http.dart' as http;

class GifProvider {
  final endpoint =
      "https://api.giphy.com/v1/gifs/trending?api_key=081Z33Gf8OaNbdK1upYCzUqPGG90MimV&limit=10&rating=g";

  Future<List<ModeloGif>> fetchGifs() async {
    final resp = await http.get(Uri.parse(endpoint));
    if (resp.statusCode == 200) {
      String body = utf8.decode(resp.bodyBytes);
      final jsonList = jsonDecode(body);

      final gifs = Gifs.fromJsonList(jsonList);
      //print(gifs.items);
      return gifs.items;
    } else {
      throw ("El error es: ${resp.statusCode}");
    }
  }
}
