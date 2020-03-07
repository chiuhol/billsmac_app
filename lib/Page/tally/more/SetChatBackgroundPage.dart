import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';

///Author:chiuhol
///2020-2-8

class SetChatBackgroundPage extends StatefulWidget {
  @override
  _SetChatBackgroundPageState createState() => _SetChatBackgroundPageState();
}

class _SetChatBackgroundPageState extends State<SetChatBackgroundPage> {
  List _photoLst = [];

  //获取bing背景图
  @protected
  _getPhotos() async {
    try {
      BaseOptions options = BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio
          .patch("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=9");
      print(response.data.toString());
      if (mounted) {
        setState(() {
          _photoLst = response.data["images"];
          _photoLst.forEach((items) {
            items.addAll({"isSelect": false});
          });
        });
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _saveBackground(photoUrl)async{
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "patch",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.patch(Address.updateChatroom(_chatroomId),
          data: {"background": photoUrl});
      print(response.data.toString());
      if (response.data["status"] == 200) {
        LocalStorage.save("background", photoUrl);
        CommonUtil.showMyToast("聊天室背景已修改");
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPhotos();
  }

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
                  builder("从手机相册选择", "", () {}),
                  SizedBox(height: 12),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 18, top: 18, bottom: 18),
                      color: MyColors.white_fe,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("选择背景图",
                                style: TextStyle(
                                    color: MyColors.black_32,
                                    fontSize: MyFonts.f_15)),
                            Padding(
                                padding: EdgeInsets.only(right: 12, top: 18),
                                child: photoWidget())
                          ]))
                ]))));
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

  Widget photoWidget() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            crossAxisCount: 3,
            childAspectRatio: 4 / 5),
        itemBuilder: itemBuilder,
        itemCount: _photoLst.length,
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _photo = _photoLst[index];
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!_photo["isSelect"]) {
            if (mounted) {
              setState(() {
                _photoLst.forEach((items) {
                  items["isSelect"] = false;
                });
                _photo["isSelect"] = true;
              });
            }
          }
          _saveBackground("https://cn.bing.com${_photo["url"]}");
        },
        child: Container(
            decoration: BoxDecoration(
              color: MyColors.white_fe,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                    color: _photo["isSelect"] == true
                        ? MyColors.orange_68
                        : MyColors.white_fe,
                    width: 5),
                image: _photo["url"] == ""?null:DecorationImage(
                    image: NetworkImage("https://cn.bing.com${_photo["url"]}"),
                    fit: BoxFit.fill))));
  }
}
