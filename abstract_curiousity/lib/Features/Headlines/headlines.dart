// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:abstract_curiousity/Features/Headlines/bloc/headline_bloc.dart';
import 'package:abstract_curiousity/Features/Headlines/services/headlinerepository.dart';
import 'package:abstract_curiousity/Features/HomePage/services/homerepository.dart';
import 'package:abstract_curiousity/Features/webView/webview.dart';
import 'package:abstract_curiousity/models/article.dart';
import 'package:abstract_curiousity/utils/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your CustomArticle model and the fetchTopHeadlines function here

class Headlines extends StatefulWidget {
  const Headlines({Key? key}) : super(key: key);

  @override
  State<Headlines> createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  List<CustomArticle> headlines = [];
  Future _refresh() async {
    BlocProvider.of<HeadlineBloc>(context).add(
      HeadlineRequested(),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocListener<HeadlineBloc, HeadlineState>(
          listener: (context, state) {
            if (state is HeadlineLoading) {
              const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            if (state is HeadlineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
            if (state is HeadlineLoaded) {
              headlines = state.articles;
            }
          },
          child: BlocBuilder<HeadlineBloc, HeadlineState>(
            builder: (context, state) {
              if (state is HeadlineLoading) {
                return const Center(child: CustomLoadingWidget());
              }
              if (state is HeadlineLoaded) {
                headlines = state.articles;
                return Column(children: [
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
                ]);
              }
              return const Center(
                child: Text("Page Not Serviced"),
              );
            },
          ),
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

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebViewApp(link: article.url)));
                _repository.incrementNumberOfArticlesRead();
                _repository.saveArticleToUserHistory(article);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 08, vertical: 7),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                        if (article.author != "")
                          Text(
                            "${article.author}",
                            style: TextStyle(
                              color: Colors.blue[200],
                            ),
                          ),
                        Text(
                          article.title,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          //number of likes, comments, and number of reads
                          Icon(
                            Icons.favorite_border,
                            color: Colors.grey[700],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "0",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),

                          Text(
                            "0",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "comments",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey[700],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "reads",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
