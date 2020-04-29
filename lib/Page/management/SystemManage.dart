import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

///Author:chiuhol
///2020-4-23

class SystemManage extends StatefulWidget {
  @override
  _SystemManageState createState() => _SystemManageState();
}

class _SystemManageState extends State<SystemManage> {
  String _qqGroup = '暂无';
  String _wechat = '暂无';
  String _emailAddress = '暂无';
  String _phoneNum = '暂无';
  TextEditingController _msgController = TextEditingController();

  @protected
  _getMsg() async {
    try {
      BaseOptions options = BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio.get(Address.getAboutUs());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _qqGroup = response.data["data"]["aboutUs"][0]["qqGroup"] ?? "暂无";
            _wechat =
                response.data["data"]["aboutUs"][0]["officialAccount"] ?? "暂无";
            _emailAddress =
                response.data["data"]["aboutUs"][0]["emailAddress"] ?? "暂无";
            _phoneNum = response.data["data"]["aboutUs"][0]["phoneNum"] ?? "暂无";
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getMsg();
  }

  _updateDialog(String title, String content) async {
    TextInputType _type;
    if(content != "暂无"){
      _msgController.text = content;
    }else{
      _msgController.text = "";
    }
    if(title == "给我们写信"){
      title = "邮箱地址";
      _type = TextInputType.emailAddress;
    }else if(title == "微信公众号"){
      _type = TextInputType.text;
    }else{
    _type = TextInputType.phone;
    }
    await showDialog(
        context: context,
        barrierDismissible: true,
        child: new SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Center(
                child: Text('修改$title',
                    style: TextStyle(
                        color: MyColors.black_33, fontSize: MyFonts.f_16))),
            contentPadding: const EdgeInsets.all(10.0),
            children: <Widget>[
              SeparatorWidget(),
              SizedBox(height: 13.5),
              Column(children: <Widget>[
                Row(children: <Widget>[
                  Text("$title：", style: TextStyle(fontSize: MyFonts.f_16)),
                  Expanded(
                      child: TextField(
                          maxLines: 1,
                          controller: _msgController,
                          keyboardType: _type,
                          cursorColor: MyColors.green_8d,
                          style: TextStyle(
                              color: MyColors.green_8d, fontSize: MyFonts.f_18),
                          decoration: InputDecoration(
                              hintText: '请输入$title',
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_16,
                                color: MyColors.red_5c,
                              ),
                              border: InputBorder.none)))
                ])
              ]),
              SizedBox(height: 13.5),
              SeparatorWidget(),
              Container(
                  height: 45,
                  child: RaisedButton(
                      color: MyColors.white_ff,
                      elevation: 0,
                      splashColor: MyColors.white_ff,
                      child: Text('修改',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyColors.green_8d,
                              fontSize: MyFonts.f_16)),
                      onPressed: () {
                        if (_msgController.text == '') {
                          CommonUtil.showMyToast("$title不能为空");
                          return;
                        }
                        if(title == "邮箱地址"){
                          if(!CommonUtil.isEmailAddress(_msgController.text)){
                            CommonUtil.showMyToast("邮箱地址格式不正确");
                            return;
                          }
                        }
                        if(title == "后台手机号码"){
                          if(!CommonUtil.isPhoneNo(_msgController.text)){
                            CommonUtil.showMyToast("手机号码格式不正确");
                            return;
                          }
                        }
                        Navigator.pop(context);
                        _updateMsg(title,_msgController.text);
                      }))
            ]));
  }

  @protected
  _updateMsg(title,content)async{
    if(title == "QQ群"){
      title = "qqGroup";
    }else if(title == "微信公众号"){
      title = "officialAccount";
    }else if(title == "邮箱地址"){
      title = "emailAddress";
    }else{
      title = "phoneNum";
    }
    try {
      BaseOptions options = BaseOptions(method: "patch");
      var dio = new Dio(options);
      var response =
      await dio.patch(Address.updateAboutUs(), data: {title: content});
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if(mounted){
          setState(() {
            if(title == "qqGroup"){
              _qqGroup = _msgController.text;
            }else if(title == "officialAccount"){
              _wechat = _msgController.text;
            }else if(title == "emailAddress"){
              _emailAddress = _msgController.text;
            }else{
              _phoneNum = _msgController.text;
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
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                      child: Text("Tips：点击需要修改的信息即可！",
                          style: TextStyle(
                              fontSize: MyFonts.f_16,
                              color: MyColors.orange_68))),
                  SeparatorWidget(),
                  rowWidget("QQ群", _qqGroup),
                  SeparatorWidget(),
                  rowWidget("微信公众号", _wechat),
                  SeparatorWidget(),
                  rowWidget("给我们写信", _emailAddress),
                  SeparatorWidget(),
                  rowWidget("后台手机号码", _phoneNum),
                  SeparatorWidget()
                ])));
  }

  Widget rowWidget(String title, String content) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _updateDialog(title, content);
        },
        child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(title,
                      style: TextStyle(
                          fontSize: MyFonts.f_16, color: MyColors.black_1a)),
                  Row(children: <Widget>[
                    Text(content,
                        style: TextStyle(
                            fontSize: MyFonts.f_16, color: MyColors.black_1a)),
                    Icon(Icons.chevron_right,
                        color: MyColors.black_1a, size: 22)
                  ])
                ])));
  }
}
