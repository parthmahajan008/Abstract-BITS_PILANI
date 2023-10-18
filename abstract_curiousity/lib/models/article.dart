// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomArticle {
  final Map<String, dynamic> source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;
  final String? summary;

  CustomArticle({
    required this.source,
    this.author,
    required this.title,
    this.description = "",
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    this.summary,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.millisecondsSinceEpoch,
      'content': content,
      'summary': summary,
    };
  }

  factory CustomArticle.fromMap(Map<String, dynamic> map) {
    return CustomArticle(
      source:
          Map<String, dynamic>.from((map['source'] as Map<String, dynamic>)),
      author: map['author'] != null ? map['author'] as String : "",
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : "",
      url: map['url'] as String,
      urlToImage: map['urlToImage'] != null ? map['urlToImage'] as String : "",
      publishedAt: DateTime.now(),
      content: map['content'] != null ? map['content'] as String : "",
      summary: map['summary'] != null ? map['summary'] as String : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomArticle.fromJson(String source) =>
      CustomArticle.fromMap(json.decode(source) as Map<String, dynamic>);
}
