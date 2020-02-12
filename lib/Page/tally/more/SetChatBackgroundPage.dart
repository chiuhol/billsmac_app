import 'package:billsmac_app/Common/CommonInsert.dart';

///Author:chiuhol
///2020-2-8

class SetChatBackgroundPage extends StatefulWidget {
  @override
  _SetChatBackgroundPageState createState() => _SetChatBackgroundPageState();
}

class _SetChatBackgroundPageState extends State<SetChatBackgroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "设置聊天背景",
        isBack: true,
        backIcon: Icon(Icons.keyboard_arrow_left,
            color: MyColors.black_32, size: 28),
        color: MyColors.white_fe,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.grey_f6,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(children: <Widget>[
            SizedBox(height: 2),
            builder("从手机相册选择", "", (){}),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
                padding: EdgeInsets.only(left: 18,top: 18,bottom: 18),
              color: MyColors.white_fe,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "选择背景图",
                      style: TextStyle(
                          color: MyColors.black_32,
                          fontSize: MyFonts.f_15
                      )
                  )
                ]
              )
            )
          ])
        )
      )
    );
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
