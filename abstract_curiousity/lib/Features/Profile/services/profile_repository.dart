import 'dart:convert';
import 'package:abstract_curiousity/globalvariables.dart';
import 'package:abstract_curiousity/httperrorhandle.dart';
import 'package:abstract_curiousity/models/user.dart';
import 'package:abstract_curiousity/utils/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  void updateNameAndBio({
    required String firebaseUid,
    required String name,
    required String bio,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/editProfile'),
        body: jsonEncode({
          "firebaseUid": firebaseUid,
          "name": name,
          "bio": bio,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Profile Details Updated");
          });
      // print(res.body);
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to Update Data');
    }
  }

  Future<CustomUser?> getCurrentNameAndBio({
    required String firebaseUid,
    required BuildContext context,
  }) async {
    CustomUser? customUser;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/getEditInfo?firebaseUid=$firebaseUid'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );
      print("----------------------");
      print(res.body);

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          customUser = CustomUser.fromJson(res.body);
          showSnackBar(context, "User Details Loaded");
        },
      );
    } catch (e) {
      print(e);
      throw Exception('Failed to Update Data');
    }

    return customUser;
  }
}
