import 'package:abstract_curiousity/Features/UserRegisteration/screens/personaliseTopics.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/extendedTextButton.dart';
import '../UserRegisteration/screens/phoneScreen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/landingScreen4.png',
                fit: BoxFit.cover,
              ),
            ),
            ExtendedTextButton(
              imageUrl: "http://pngimg.com/uploads/google/google_PNG19635.png",
              title: "Continue With Google",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChooseTopics(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ExtendedTextButton(
              icon: Icons.person,
              title: "Continue With Email/Phone",
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PhoneScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
