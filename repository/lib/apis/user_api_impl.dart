import 'dart:async';

import 'package:lumbung_common/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

import 'package:core/utils/log.dart';

import 'package:core/apis/auth_api.dart';
import 'package:core/apis/user_api.dart';

import '../utils/api_utils.dart';

class UserApiImpl extends UserApi {
  fba.FirebaseAuth auth = fba.FirebaseAuth.instance;
  static Map<String, String> headers = {
    'X-Secret-Key': "494b6832-6490-43b1-a8a3-53ac53bba864"
  };

  late final String url;
  UserApiImpl(this.url);

  @override
  Future<User?> currentUser() async {
    fba.User? authUser = auth.currentUser;
    if (authUser != null) {
      User currentUser = ApiUtils.getUserFromFirebaseUser(authUser);
      String? role = await getUserRole(currentUser.email ?? "");
      if (role?.isNotEmpty ?? false) {
        currentUser = currentUser.copyWith(role: role);
      }
      return currentUser;
    } else {
      return null;
    }
  }

  Future<String?> getUserRole(String email) async {
    try {
      Map<String, dynamic> body = {"email": email};

      dynamic apiResponse = await postMethod(
        url + '/user/get',
        body: body,
        headers: headers,
        // noJsonEncode: false,
      );
      Log.setLog("getUserRole apiResponse: ${apiResponse.toString()}",
          method: "getUserRole");

      if (apiResponse != null) {
        if (apiResponse["status"] == true) {
          final response = apiResponse?["response"];

          return response?["role"] ?? "";
        } else {
          final message = apiResponse["message"];
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e, s) {
      return null;
    }
  }
}
