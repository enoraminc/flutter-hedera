import 'package:lumbung_common/api/base_api.dart';
import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/permissions.dart';
import 'package:lumbung_common/model/user.dart';

class UserData {
  final User? user;
  final Permissions? permissions;
  UserData({
    this.user,
    this.permissions,
  });
}

abstract class UserApi extends BaseRepository {
  Future<UserData?> currentUser();

  Future<List<User>> getAllUser();
  Future<Permissions> getUserPermissions(String id);
  Future<Permissions> setUserPermissions(String id, Permissions permissions);
}
