import 'dart:convert';
import 'package:abstract_curiousity/globalvariables.dart';
import 'package:abstract_curiousity/models/article.dart';
import 'package:abstract_curiousity/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  final firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  static const String apiKey = API_KEY; // Replace with your News API key
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<CustomArticle>> fetchNewsByTopic(String topic) async {
    final String uri =
        '$baseUrl/top-headlines?country=in&category=$topic&language=en&apiKey=$apiKey';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok' && data['articles'] != null) {
        List<CustomArticle> articles = (data['articles'] as List)
            .map((articleData) => CustomArticle.fromMap(articleData))
            .toList();
        await saveArticlesToFirestore(articles);
        return articles;
      } else {
        throw Exception('Failed to fetch headlines');
      }
    } else {
      throw Exception('Failed to fetch headlines');
    }
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> saveArticlesToFirestore(List<CustomArticle> articles) async {
    if (Firebase.apps.isEmpty) {
      await initializeFirebase();
    }

    final collection = firestore.collection("articles");
    final querySnapshot = await firestore.collection("articles").get();
    if (querySnapshot.docs.isNotEmpty) {
      final existingURLs = <String, bool>{};
      for (var doc in querySnapshot.docs) {
        final url = doc.data()["url"] as String;
        existingURLs[url] = true;
      }
      // final urls =
      //     querySnapshot.docs.map((doc) => doc.data()["url"] as String).toList();
      for (CustomArticle article in articles) {
        final articleURL = article.url;
        if (!existingURLs.containsKey(articleURL)) {
          await collection.add(article.toMap());
        }
      }
    } else {
      for (CustomArticle article in articles) {
        await collection.add(article.toMap());
      }
    }
  }

  Future<String> fetchRandomQuote() async {
    final response =
        await http.get(Uri.parse('https://api.quotable.io/random'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['content'] as String;
    } else {
      throw Exception('Failed to fetch a random quote');
    }
  }

  Future<CustomUser?> getUserData(String userId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final usersCollection = firestore.collection("users");

      final userDoc = await usersCollection.doc(userId).get();
      if (userDoc.exists) {
        final userData =
            CustomUser.fromMap(userDoc.data() as Map<String, dynamic>);
        return userData;
      } else {
        return null; // User not found
      }
    } catch (e) {
      // Handle any potential errors here
      return null;
    }
  }

  Future<void> incrementNumberOfArticlesRead() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final usersCollection = firestore.collection("users");

      // Create a reference to the user's document in the users collection
      final userDocRef = usersCollection.doc(_auth.currentUser!.uid);

      // Increment the numberOfArticles field in the user's document by 1
      await userDocRef.update({'numberOfArticles': FieldValue.increment(1)});
    } catch (e) {
      throw Exception("Firebase Error Occured");
    }
  }

  Future<List<CustomArticle>> fetchNews() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final articlesCollection = firestore.collection("articles");

      final querySnapshot = await articlesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        final articles = querySnapshot.docs
            .map((doc) => CustomArticle.fromMap(doc.data()))
            .toList();
        return articles;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
