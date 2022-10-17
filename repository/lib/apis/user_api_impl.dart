import 'dart:async';

import 'package:lumbung_common/model/user.dart';
import 'package:lumbung_common/model/permissions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

import 'package:hedera_core/utils/log.dart';

import 'package:hedera_core/apis/auth_api.dart';
import 'package:hedera_core/apis/user_api.dart';

import '../utils/api_utils.dart';
import 'package:lumbung_common/base/base_repository.dart';

class UserApiImpl extends UserApi {
  fba.FirebaseAuth auth = fba.FirebaseAuth.instance;
  static Map<String, String> headers = {
    'X-Secret-Key': "494b6832-6490-43b1-a8a3-53ac53bba864"
  };

  late final String url;
  UserApiImpl(this.url);

  @override
  Future<UserData?> currentUser() async {
    fba.User? authUser = auth.currentUser;
    if (authUser != null) {
      User currentUser = ApiUtils.getUserFromFirebaseUser(authUser);
      UserData? userData = await getUserData(currentUser.email ?? "");
      if (userData?.user?.role?.isNotEmpty ?? false) {
        currentUser = currentUser.copyWith(role: userData?.user?.role);
      }

      Log.setLog("${userData?.user?.email} ${userData?.user?.role}",
          method: "UserApiImpl.currentUser");

      return UserData(
        user: currentUser,
        permissions: userData?.permissions,
      );
    } else {
      return null;
    }
  }

  Future<UserData?> getUserData(String email) async {
    try {
      Map<String, dynamic> body = {"email": email};

      final data = await request(
        '$url/user/get',
        RequestType.post,
        useSecretKey: true,
        body: body,
      );

      User user = User.fromMap(data ?? {});
      Permissions permissions = Permissions.fromMap(data?["permissions"] ?? {});

      return UserData(
        user: user,
        permissions: permissions,
      );
    } catch (e, s) {
      Log.setLog("$e $s", method: "getUserData");
      rethrow;
    }
  }

  @override
  Future<List<User>> getAllUser() async {
    try {
      Map<String, dynamic> body = {"roles": "Admin,PAgent"};

      final data = await request(
        '$url/user/all',
        RequestType.post,
        useSecretKey: true,
        body: body,
      );

      return data.map<User>((e) => User.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getAllUser");
      rethrow;
    }
  }

  @override
  Future<Permissions> getUserPermissions(String id) async {
    try {
      Map<String, dynamic> body = {"id": id};

      final data = await request(
        '$url/user/permission',
        RequestType.post,
        useSecretKey: true,
        body: body,
      );

      return Permissions.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "getUserPermissions");
      rethrow;
    }
  }

  @override
  Future<Permissions> setUserPermissions(
      String id, Permissions permissions) async {
    try {
      Map<String, dynamic> body = {
        "id": id,
        "permissions": permissions.toMap(),
      };

      final data = await request(
        '$url/user/permission/set',
        RequestType.post,
        useSecretKey: true,
        body: body,
      );

      return Permissions.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "setUserPermissions");
      rethrow;
    }
  }
}
