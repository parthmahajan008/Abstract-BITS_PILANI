// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:abstract_curiousity/Features/Headlines/headlines.dart';
import 'package:abstract_curiousity/Features/HomePage/services/homerepository.dart';
import 'package:abstract_curiousity/models/article.dart';
import 'package:flutter/material.dart';

// Import your CustomArticle model and the fetchTopHeadlines function here

class CategoricalArticles extends StatefulWidget {
  final String topic;
  const CategoricalArticles({super.key, required this.topic});

  @override
  State<CategoricalArticles> createState() => _CategoricalArticlesState();
}

class _CategoricalArticlesState extends State<CategoricalArticles> {
  final HomeRepository _homeRepository = HomeRepository();

  List<CustomArticle> headlines = [];
  Future _refresh() async {
    _homeRepository.fetchNewsByTopic(widget.topic).then((articles) {
      setState(() {
        headlines = articles;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _homeRepository.fetchNewsByTopic(widget.topic).then((articles) {
      setState(() {
        headlines = articles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            ArticleListBuilder(headlines: headlines, refresh: _refresh),
          ],
        ),
      ),
    );
  }
}
