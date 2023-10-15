import 'package:abstract_curiousity/utils/models/topicmodel.dart';

import 'package:flutter/material.dart';

class ChooseTopics extends StatefulWidget {
  static const String routeName = '/personalise-topics';
  const ChooseTopics({super.key});

  @override
  State<ChooseTopics> createState() => _ChooseTopicsState();
}

class _ChooseTopicsState extends State<ChooseTopics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: const TopicSelectorPage(),
    );
  }
}
