import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';

import 'SetChatBackgroundPage.dart';
import 'UpDateChatNamePage.dart';

///Author:chiuhol
///2020-2-8

class MoreMainPage extends StatefulWidget {
  @override
  _MoreMainPageState createState() => _MoreMainPageState();
}

class _MoreMainPageState extends State<MoreMainPage> {
  String _chatName = "";

  @protected
  _getChatName()async{
    String _name = await LocalStorage.get("chatName").then((result) {
        return result;
      });
    if(mounted){
      setState(() {
        _chatName = _name;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getChatName();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "聊天信息",
          isBack: true,
          backIcon: Icon(Icons.keyboard_arrow_left,
              color: MyColors.black_32, size: 28),
          color: MyColors.white_fe,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: Column(children: <Widget>[
              Container(
                  color: MyColors.white_fe,
                  padding: EdgeInsets.only(left: 18, top: 18, bottom: 18),
                  child: Row(children: <Widget>[
                    Column(children: <Widget>[
                      ClipOval(
                          child: Image.network(
                              'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1379686624,47059782&fm=26&gp=0.jpg',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover)),
                      SizedBox(height: 8),
                      Center(
                          child: Text("chiuhol",
                              style: TextStyle(
                                  color: MyColors.black_32,
                                  fontSize: MyFonts.f_15)))
                    ]),
                    SizedBox(width: 18),
                    Column(children: <Widget>[
                      ClipOval(
                          child: Image.network(
                              'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1379686624,47059782&fm=26&gp=0.jpg',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover)),
                      SizedBox(height: 8),
                      Center(
                          child: Text("chiuhol",
                              style: TextStyle(
                                  color: MyColors.black_32,
                                  fontSize: MyFonts.f_15)))
                    ])
                  ])),
              SizedBox(height: 12),
              builder("群聊名称", _chatName, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpDateChatNamePage()),
                ).then((result) {
                  print(result);
                  if (result != null) {
                    setState(() {
                      _chatName = result;
                    });
                  }
                });
              }),
              SeparatorWidget(),
              builder("设置当前聊天背景", "", () {
                CommonUtil.openPage(context, SetChatBackgroundPage());
              })
            ])));
  }

  Widget builder(String title, String subTitle, Function function) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          function();
        },
        child: Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 18),
            color: MyColors.white_fe,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(title,
                      style: TextStyle(
                          color: MyColors.black_32, fontSize: MyFonts.f_15)),
                  Row(children: <Widget>[
                    Text(subTitle,
                        style: TextStyle(
                            color: MyColors.grey_e2, fontSize: MyFonts.f_15)),
                    Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: MyColors.grey_e2,
                    )
                  ])
                ])));
  }
}
