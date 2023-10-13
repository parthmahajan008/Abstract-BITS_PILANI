//

// Path: lib/Features/Edit%20Profile/edit_profile.dart
// Compare this snippet from lib/Features/Profile/_components/widgets/danger_modal.dart:
import 'package:abstract_curiousity/utils/widgets/extendedTextButton.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController userNameeditingController = TextEditingController();
  TextEditingController bioEditingController = TextEditingController();

  String _name = 'John Doe';
  String _bio = 'Hello, world!';
  String _userName = "alpha23";

  void _onNameChanged(String value) {
    setState(() {
      _name = value;
    });
  }

  void _onBioChanged(String value) {
    setState(() {
      _bio = value;
    });
  }

  void _onUserNameChanged(String value) {
    setState(() {
      _userName = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1648183185045-7a5592e66e9c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2488&q=80",
                ),
              ),
            ),
            CustomTextField(
              controller: nameEditingController,
              hintText: "Enter your Name",
              onPressed: () {
                _onNameChanged(nameEditingController.text);
              },
            ),
            CustomTextField(
              controller: userNameeditingController,
              hintText: "Enter your UserName",
              onPressed: () {
                _onUserNameChanged(userNameeditingController.text);
              },
            ),
            CustomTextField(
              controller: bioEditingController,
              hintText: "Enter your Bio",
              onPressed: () {
                _onBioChanged(bioEditingController.text);
              },
            ),
            const Expanded(
              child: SizedBox(
                height: 0,
              ),
            ),
            ExtendedTextButton(
              color: Colors.grey.shade900,
              title: "Save Changes",
              onPressed: () {
                print("$_name $_bio $_userName");
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onPressed,
  });
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: TextFormField(
        onChanged: (value) => onPressed(),
        enableSuggestions: true,
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
