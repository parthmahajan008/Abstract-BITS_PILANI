import 'package:abstract_curiousity/utils/models/topicmodel.dart';
import 'package:flutter/material.dart';

class ChooseTopics extends StatefulWidget {
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const TopicSelectorPage(),
    );
  }
}
