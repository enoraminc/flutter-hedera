import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:lumbung_common/model/user.dart';

class ApiUtils {
  // FirebaseStorage fb = FirebaseStorage.instance;

  static User getUserFromFirebaseUser(auth.User fUser) {
    User user = User(
      id: fUser.uid,
      email: fUser.email,
      displayName: fUser.displayName,
      avatarUrl: fUser.photoURL,
      role: "Guest",
    );
    return user;
  }
}
