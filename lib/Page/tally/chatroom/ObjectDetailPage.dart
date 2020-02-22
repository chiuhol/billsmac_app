import 'package:billsmac_app/Common/CommonInsert.dart';

import 'ChatroomMainPage.dart';
import 'UpdateObjectPage.dart';

///Author:chiuhol
///2020-2-22

class ObjectDetailPage extends StatefulWidget {
  @override
  _ObjectDetailPageState createState() => _ObjectDetailPageState();
}

class _ObjectDetailPageState extends State<ObjectDetailPage> {
  String _avatar = '';
  String _nikeName = '';
  String _days = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _avatar =
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1908196590,4061628990&fm=11&gp=0.jpg';
    _nikeName = '小不点';
    _days = '7';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "",
          isBack: true,
          backIcon: Icon(Icons.keyboard_arrow_left,
              color: MyColors.black_32, size: 28),
          color: MyColors.white_fe,
          rightEvent: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              CommonUtil.openPage(context, UpdateObjectPage());
            },
            child: Icon(Icons.border_color,color: MyColors.black_32,size: 18),
          ),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_e2,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: ClipOval(
                              child: Image.network(_avatar,
                                  width: 90, height: 90, fit: BoxFit.cover))),
                      Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(_nikeName,
                              style: TextStyle(
                                  color: MyColors.black_32,
                                  fontSize: MyFonts.f_22,
                                  fontWeight: FontWeight.bold))),
                      RichText(
                          text: TextSpan(
                              text: '和' + _nikeName + '在一起的第',
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_14),
                              children: <TextSpan>[
                            TextSpan(
                              text: _days,
                              style: TextStyle(
                                  color: MyColors.orange_67,
                                  fontSize: MyFonts.f_22,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '天',
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_14),
                            )
                          ])),
                      Container(
                          height: 45.0,
                          margin: EdgeInsets.only(top: 40.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              color: MyColors.white_fe),
                          child: new SizedBox.expand(
                              child: new RaisedButton(
                            onPressed: () {
                              CommonUtil.openPage(context, ChatroomMainPage());
                            },
                            color: Colors.transparent,
                            elevation: 0,
                            // 正常时阴影隐藏
                            highlightElevation: 0,
                            // 点击时阴影隐藏
                            child: new Text('发消息',
                                style: TextStyle(
                                    fontSize: 18.0, color: MyColors.blue_3f)),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(45.0)),
                          ))),
                      Container(
                          height: 45.0,
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              color: MyColors.white_fe),
                          child: new SizedBox.expand(
                              child: new RaisedButton(
                            onPressed: () {},
                            color: Colors.transparent,
                            elevation: 0,
                            // 正常时阴影隐藏
                            highlightElevation: 0,
                            // 点击时阴影隐藏
                            child: new Text('删除',
                                style: TextStyle(
                                    fontSize: 18.0, color: MyColors.blue_3f)),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(45.0)),
                          )))
                    ]))));
  }
}
