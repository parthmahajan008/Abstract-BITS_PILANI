import 'dart:convert';

import 'package:abstract_curiousity/globalvariables.dart';
import 'package:abstract_curiousity/models/article.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<List<CustomArticle>> fetchNewsByTopic(String topic) async {
    final String apiUrl = '$uri/api/getNewsByCategory?category=$topic';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'ok' && data['articles'] != null) {
        List<CustomArticle> articles = (data['articles'] as List)
            .map((articleData) => CustomArticle.fromMap(articleData))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to fetch headlines');
      }
    } else {
      throw Exception('Failed to fetch headlines');
    }
  }
}
