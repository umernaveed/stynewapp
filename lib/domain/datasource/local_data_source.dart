import 'package:straight_to_yard/data/models/user/user.dart';

abstract class LocalDataSource {
  Future<bool> saveUser(User user);

  Future<bool> deleteUser();
  Future<User> getUser();
  Future<String> getAccessToken();
  Future<String> getLoginToken();
  Future<void> loggedIN({bool isLoggedIn = true});
  Future<bool> isLoggedIn();
  User getInstantUser();
  Future<String> getAppliedCacheClearVersion();
  Future<void> saveAppliedCacheClearVersion(String version);
  Future<void> clearCustomerCache();
}
