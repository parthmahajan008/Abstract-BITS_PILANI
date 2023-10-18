import 'package:abstract_curiousity/Features/HomePage/CategoryNewsPage.dart';
import 'package:abstract_curiousity/Features/webView/webview.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = PageController(
    initialPage: 0,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: const [
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.shield_moon,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Seeker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(
              Icons.lightbulb_outline,
              color: Colors.yellowAccent,
              size: 25,
            ),
            Text(
              ' 6',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: "For You",
              ),
              Tab(text: "Entertainment"),
              Tab(text: "Business"),
              Tab(text: "Technology"),
              Tab(text: "Politics"),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: const TabBarView(
          children: [
            ForYouPage(),
            CategoricalArticles(topic: "entertainment"),
            CategoricalArticles(topic: "business"),
            CategoricalArticles(topic: "technology"),
            CategoricalArticles(topic: "politics"),
          ],
        ),
      ),
    );
  }
}

class ForYouPage extends StatelessWidget {
  const ForYouPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_moon,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Seeker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.yellowAccent,
                    size: 25,
                  ),
                  Text(
                    ' 6',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //a container to view a quote daily image from the internet
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewApp(
                      link: "theverge.com",
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Quote of the day',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1494178270175-e96de2971df9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2048&q=80",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
