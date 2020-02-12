/// @author chiuhol
/// Basic Constant

class BaseCommon {
  ///引导图
  static const ImageUrl = "ImageUrl";

  ///图片导入头
  static const String ImagePath = "asset/images/";

  ///默认倒计时60s
  static const int VCODE_END_TIME = 60;

  ///用户信息
  static const TOKEN = "TOKEN";
  static const USER = "USER";
  static const USER_ID = "user_id";
  static const USER_NAME = "user_name";
  static const USER_AVATAR = 'user_avatar';
  static const USER_SEX = 'user_sex';
  static const USER_NICKNAME = 'user_nickname';
  static const USER_PHONE = 'user_phone';
  static const USER_PASSWORD = 'user_password';
  static const USER_WECHAT_OPENID = 'user_wechat_openid';
  static const USER_WEIBO_OPENID = 'user_weibo_openid';
  static const FIRST_TIME_LOGIN = 'first_time_login';

  static const HISTORY_SEARCH = "HISTORY_SEARCH";
  static const BALANCE = "balance";

  static const DIV_NAME = 'div_name';

  /// 物流信息
  static const LOGISTICS_ID = "logistics_id";
  static const LOGISTICS_NAME = "logistics_name";

  ///获取图片，默认.png
  static String getImage(String image, {String type: ".png"}) {
    return ImagePath + image + type;
  }

  ///第三方授权信息
  static const String WECHAT_APPID = 'wx1da5582595aac599';
  static const String QQ_APPID = '1109865862';
  static const String QQ_APPKEY = 'V5Fu88SaLtRxcoi7';

  ///server error
  static const String SERVER_ERROR = '服务器暂无响应';

  /// 环信登录密码
  static const HX_PASSWORD = "yiling@123";

  static int easeNowTime;
  static int pageSize = 10;

  ///硬件设备mac
  static const String divMac = 'divMac';
}
