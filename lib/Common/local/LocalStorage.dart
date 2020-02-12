import 'package:shared_preferences/shared_preferences.dart';
import 'package:billsmac_app/Common/manager/HttpManager.dart';
import 'package:billsmac_app/Common/BaseCommon.dart';

class LocalStorage {
  static SharedPreferences _preferences;

  static int userId; //用户id
  static String token;

  static init() async {
    _preferences = await SharedPreferences.getInstance();

    ///获取本地的用户信息
    userId = _preferences.getInt(BaseCommon.USER_ID) ?? null;
    token = _preferences.getString(BaseCommon.TOKEN);
    HttpManager.onLogin(token ?? null);
  }

  static save(String key, value) {
    SharedPreferences prefs = _preferences;
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
  }

  static get(String key) {
    SharedPreferences prefs = _preferences;
    return prefs.get(key);
  }

  static remove(String key) {
    SharedPreferences prefs = _preferences;
    prefs.remove(key);
  }

  ///获取搜索历史
  static List<String> getSearchHistory() {
    return _preferences.getStringList("searchHistory");
  }

  static setSearchHistory(List<String> infos) {
    _preferences.setStringList("searchHistory", infos);
  }

  ///清空搜索历史
  static clearSearchHistory() {
    _preferences.remove("searchHistory");
  }

  ///用于更新登陆状态
  static updateLoginState(int userId, String newToken) {
//    JpushManager.setAlias(userId);// to do
    LocalStorage.userId = userId;
    print('LocalStorage.userId');
    print(LocalStorage.userId);
    LocalStorage.token = newToken;
    HttpManager.onLogin(newToken);

    _preferences.setInt(BaseCommon.USER_ID, userId);
    _preferences.setString(BaseCommon.TOKEN, newToken);
  }

  ///用于注销登陆
  static void setLogoutState() {
//    JpushManager.deleteAlias();// to do
    LocalStorage.userId = null;
    LocalStorage.token = null;
    HttpManager.onLogout();
    _preferences.remove(BaseCommon.USER_ID);
    _preferences.remove(BaseCommon.TOKEN);

//    GlobalStore.store.dispatch(
//        GlobalAction.changeUserPermission(UserPermission.NORMAL));
  }
}
