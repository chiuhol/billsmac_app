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

  //修改用户资料
  static String updatePersonalMsg(String userId){
    return '$host/users/$userId';
  }

  //修改用户密码
  static String updatePwd(String userId){
    return '$host/users/updatePwd/$userId';
  }

  //注销用户
  static String deleteUser(String userId){
    return '$host/users/$userId';
  }

  //根据用户ID获取聊天室信息
  static String getChatroom(String id){
    return '$host/chatroom/$id';
  }

  //根据用户I修改聊天室信息
  static String updateChatroom(String id){
    return '$host/chatroom/$id';
  }

  //根据聊天室ID获取聊天内容
  static String getChatContent(String id){
    return '$host/chatroom/$id/chatContent';
  }

  //根据聊天室ID增加聊天内容
  static String saveChatContent(String id){
    return '$host/chatroom/$id/chatContent';
  }

  //根据聊天室ID删除聊天内容
  static String updateChatContent(String id,String chatContentId){
    return '$host/chatroom/$id/chatContent/$chatContentId';
  }

  //获取社区文章
  static String getActicles(){
    return '$host/communityActicles';
  }

  //根据ID获取社区文章
  static String getActiclesById(String id){
    return '$host/communityActicles/$id';
  }

  //根据ID获取社区文章评论
  static String getArticleComment(String id){
    return '$host/communityActicles/$id/comments';
  }

  //保存社区文章评论
  static String saveComment(String id){
    return '$host/communityActicles/$id/comments';
  }

  //根据ID修改社区文章
  static String updateArticlesById(String id){
    return '$host/communityActicles/$id';
  }

  //根据ID修改社区文章某个评论
  static String updateCommentById(String articleId,String commentId){
    return '$host/communityActicles/$articleId/comments/$commentId';
  }

  //新建反馈
  static String saveFeedback(String userId){
    return '$host/feedback/$userId';
  }

  //查看反馈历史
  static String getFeedback(String userId){
    return '$host/feedback/$userId';
  }

  //获取用户的对象列表
  static String getObjects(String userId){
    return '$host/users/$userId/objects/$userId';
  }

  //增加用户对象
  static String saveObjects(String userId){
    return '$host/users/$userId/objects';
  }

}
