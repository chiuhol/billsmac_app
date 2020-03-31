import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Widget/SubprojectWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../LoginPage.dart';
import 'CheckIDPage.dart';
import 'UpdatePasswordPage.dart';

///Author:chiuhol
///2020-2-8

class AccountSecurityPage extends StatefulWidget {
  @override
  _AccountSecurityPageState createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  String _phone = "去绑定";
  String _wetChat = "去绑定";
  String _qq = "去绑定";

  @protected
  _deleteAccount() async {
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "delete",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.delete(Address.deleteUser(_userId));
      print(response.data.toString());
      if (response.data["status"] == 204) {
        CommonUtil.showMyToast("注销成功");
        CommonUtil.openPage(context, LoginPage());
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _showTip() {
    return showCupertinoDialog(
        context: context,
        builder: (_) =>
            CupertinoAlertDialog(content: Text('确定注销改账号吗？'), actions: <Widget>[
              CupertinoDialogAction(
                  child: Text(
                    '取消',
                    style: TextStyle(color: MyColors.red_34),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                child: Text(
                  '确定',
                  style: TextStyle(color: MyColors.orange_68),
                ),
                onPressed: () {
                  _deleteAccount();
                },
              )
            ]));
  }

  @protected
  _getLocalStorage()async{
    String _account = await LocalStorage.get("phone").then((result) {
      return result;
    });
    if(mounted){
      setState(() {
        _phone = _account;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "账号安全与绑定",
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28),
            color: MyColors.white_fe),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(children: <Widget>[
                  SizedBox(height: 2),
                  SubprojectWidget(
                      title: '手机号',
                      icon: 0xe671,
                      iconColor: MyColors.grey_e4,
                      subTitle: _phone,rout: CheckIDPage(phone: _phone)),
                  SeparatorWidget(),
                  SubprojectWidget(
                      title: '修改密码', icon: 0xe626, iconColor: MyColors.grey_e4,rout: UpdatePasswordPage()),
                  SizedBox(height: 24),
                  SubprojectWidget(
                      title: '微信',
                      icon: 0xe6ea,
                      iconColor: MyColors.grey_e4,
                      subTitle: _wetChat),
                  SeparatorWidget(),
                  SubprojectWidget(
                      title: 'QQ',
                      icon: 0xe50b,
                      iconColor: MyColors.grey_e4,
                      subTitle: _qq),
                  SizedBox(height: 24),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _showTip,
                      child: Container(
                          color: MyColors.white_fe,
                          padding: EdgeInsets.only(top: 18, bottom: 18),
                          child: Center(
                              child: Text("注销账号",
                                  style: TextStyle(
                                      color: MyColors.red_34,
                                      fontSize: MyFonts.f_15)))))
                ]))));
  }
}
