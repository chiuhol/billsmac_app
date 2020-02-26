/// @author chiuhol
/// API Address

String host = 'http://116.62.141.151';

class Address {
  static String getStories(){
    return 'https://news-at.zhihu.com/api/4/news/latest';
  }

  //登录
  static String login(){
    return '$host/users/login';
  }

  //获取用户资料
  static String getPersonalMsg(){
    return '$host/users/login';
  }

}
