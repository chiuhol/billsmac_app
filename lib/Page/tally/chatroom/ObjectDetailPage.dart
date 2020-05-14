import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';

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
  num _days = 0;
  var object;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getObject();
  }

  @protected
  _getObject()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options =
      BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio.get(Address.getObject(_userId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        object = response.data["data"]["objects"];
        if (mounted) {
          setState(() {
            if(object.length != 0){
              _avatar = object[0]["avatar"];
              _nikeName = object[0]["nikeName"];
              DateTime now = DateTime.now();
              DateTime createdAt = DateTime.parse(object[0]["createdAt"]);
              var hours = now.difference(createdAt).inDays;
              _days = hours;
            }
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
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
              CommonUtil.openPage(context, UpdateObjectPage(object: {
                "_id":object[0]["_id"],
                "nikeName":object[0]["nikeName"],
                "calledMe":object[0]["calledMe"],
                "avatar":object[0]["avatar"],
                "createdAt":object[0]["createdAt"]
              }));
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
                              text: _days.toString(),
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
                              CommonUtil.openPage(context, ChatroomMainPage(object: {
                                "nikeName":_nikeName,
                                "avatar":_avatar
                              }));
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
                      SizedBox(height: 10),
                      Text("Tip:无聊的话可以陪我聊天哦~",style: TextStyle(
                        fontSize: MyFonts.f_14,
                        color: MyColors.orange_68
                      ))
                    ]))));
  }
}
