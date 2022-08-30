import 'package:lumbung_common/model/user.dart';
import 'package:lumbung_common/api/base_api.dart';

abstract class UserApi extends GoRestApi {
  Future<User?> currentUser();
}
