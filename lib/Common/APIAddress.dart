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

  //创建用户
  static String createUser(){
    return '$host/users';
  }

  //获取用户资料
  static String getPersonalMsg(){
    return '$host/users/login';
  }

  //获取用户列表
  static String getUsers(){
    return '$host/users';
  }

  //获取管理员列表
  static String getManagers(){
    return '$host/managers';
  }

  //添加管理员
  static String addManagers(){
    return '$host/managers';
  }

  //修改管理员信息
  static String updateManagers(String managerId){
    return '$host/managers/$managerId';
  }

  //管理员登录
  static String managerLogin(){
    return '$host/managers/login';
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

  //获取所有反馈
  static String getAllFeedback(){
    return '$host/feedback';
  }

  //修改反馈
  static String updateFeedback(String feedbackId){
    return '$host/feedback/$feedbackId';
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

  //获取社区文章
  static String getArticles(){
    return '$host/communityActicles';
  }

  //获取全部社区文章
  static String getAllArticles(){
    return '$host/communityActicles/manager';
  }

  //新建社区文章
  static String newArticles(){
    return '$host/communityActicles';
  }

  //修改社区文章
  static String updateArticles(String articleId){
    return '$host/communityActicles/$articleId';
  }

  //添加用户语料
  static String addCorpus(String userId){
    return '$host/users/$userId/corpus';
  }

  //获取用户语料
  static String getCorpus(String userId){
    return '$host/users/$userId/corpus';
  }

  //修改用户语料
  static String updateCorpus(String userId,String corpusId){
    return '$host/users/$userId/corpus/$corpusId';
  }

  //获取关于我们
  static String getAboutUs(){
    return '$host/aboutUs';
  }

  //修改关于我们
  static String updateAboutUs(){
    return '$host/aboutUs';
  }

  //获取年度统计数据
  static String static(String chatroomId){
    return '$host/chatroom/$chatroomId/chatContent/static';
  }

  //根据类别获取统计数据
  static String staticByType(String chatroomId){
    return '$host/chatroom/$chatroomId/chatContent/staticByType';
  }

  //获取用户统计数据
  static String getUserStatic(){
    return '$host/usersStatic';
  }

  //取消社区文章关注
  static String cancelArticleFocus(){
    return '$host/communityActicles/cancelFocusArticle';
  }

  //新增社区文章关注
  static String articleFocus(){
    return '$host/communityActicles/focusArticle';
  }

  //取消社区文章好问题
  static String cancelArticleGoods(){
    return '$host/communityActicles/cancelGood';
  }

  //新增社区文章好问题
  static String articleGoods(){
    return '$host/communityActicles/good';
  }

  //新增社区文章评论点赞
  static String commentAgree(String articleId){
    return '$host/communityActicles/$articleId/comments/agreeComment';
  }

  //取消社区文章评论点赞
  static String cancelCommentAgree(String articleId){
    return '$host/communityActicles/$articleId/comments/cancelAgreeComment';
  }

  //新增社区文章评论喜欢
  static String commentLike(String articleId){
    return '$host/communityActicles/$articleId/comments/likeComment';
  }

  //取消社区文章评论喜欢
  static String cancelCommentLike(String articleId){
    return '$host/communityActicles/$articleId/comments/cancelLikeComment';
  }
}
