import 'package:abstract_curiousity/Features/webView/_components/navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  final String link;
  const WebViewApp({
    Key? key,
    required this.link,
  }) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) {
            // final host = Uri.parse(navigation.url).host;

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       'Blocking navigation to $host',
            //     ),
            //   ),
            // );
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(
        Uri.parse(widget.link),
      );
  }

  @override
  Widget build(BuildContext context) {
    String _extractedContent = "";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          NavigationControls(controller: controller),
          // Menu(controller: controller),
        ],
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.black87,
        backgroundColor: Colors.black,
        onPressed: () async {
          final mainContent = await controller.runJavaScriptReturningResult('''

var mainContent = document.querySelector('body').innerText;
mainContent;''');

          setState(() {
            _extractedContent = mainContent.toString();

            // print(_extractedContent);
          });
          // ignore: use_build_context_synchronously
          showModalBottomSheet(
            enableDrag: true,
            useSafeArea: true,
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 1000,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    _extractedContent,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.stream_outlined,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
