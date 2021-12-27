import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class Movies extends ChangeNotifier {
  final String url =
      'https://api.themoviedb.org/3/movie/popular?api_key=65302d9fd57dda3ea2ba86f370ab6b7f&language=en-US&page=1';
  Future<MovieModel> fetchMovie() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }
}
