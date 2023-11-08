// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:abstract_curiousity/Features/Headlines/services/headlinerepository.dart';
import 'package:abstract_curiousity/Features/HomePage/services/homerepository.dart';
import 'package:abstract_curiousity/Features/webView/webview.dart';
import 'package:abstract_curiousity/models/article.dart';
import 'package:flutter/material.dart';

// Import your CustomArticle model and the fetchTopHeadlines function here

class Headlines extends StatefulWidget {
  const Headlines({Key? key}) : super(key: key);

  @override
  State<Headlines> createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  final HeadlineRepository _headlineRepository = HeadlineRepository();

  List<CustomArticle> headlines = [];
  Future _refresh() async {
    _headlineRepository.fetchTopHeadlines().then((articles) {
      setState(() {
        headlines = articles;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _headlineRepository.fetchTopHeadlines().then((articles) {
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
            const Center(
              child: Text(
                "Headlines",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ArticleListBuilder(headlines: headlines, refresh: _refresh),
          ],
        ),
      ),
    );
  }
}

class ArticleListBuilder extends StatefulWidget {
  final List<CustomArticle> headlines;
  final Future<void> Function() refresh;
  const ArticleListBuilder({
    Key? key,
    required this.headlines,
    required this.refresh,
  }) : super(key: key);

  @override
  State<ArticleListBuilder> createState() => _ArticleListBuilderState();
}

class _ArticleListBuilderState extends State<ArticleListBuilder> {
  HomeRepository _repository = HomeRepository();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: widget.refresh,
        child: ListView.builder(
          itemCount: widget.headlines.length,
          itemBuilder: (context, index) {
            final article = widget.headlines[index];

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WebViewApp(link: article.url)));
                    _repository.incrementNumberOfArticlesRead();
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      trailing: Column(
                        children: [
                          article.urlToImage != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    article.urlToImage!,
                                  ), // No matter how big it is, it won't overflow
                                  onBackgroundImageError:
                                      (exception, stackTrace) {},
                                )
                              : const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/landingScreen5.png"),
                                )
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (article.author != "")
                            Text(
                              "Source : ${article.author}",
                              style: TextStyle(
                                color: Colors.blue[200],
                              ),
                            )
                        ],
                      ),
                      subtitle: article.description != null
                          ? Text(
                              article.description!,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    color: Colors.white30,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
