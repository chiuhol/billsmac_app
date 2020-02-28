import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Widget/photo_crop.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:billsmac_app/Common/DataBase/SqliteHelper.dart';

///Author:chiuhol
///2020-2-6

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String _nikeName = '来做客';
  String _avatar = "";
  String _sex = "男";
  String _identity = "选择我的身份";
  String _location = "请选择我的所在地";
  String _birthday = "她想知道你的生日";

  List _sexLst = [
    {"name": "男", "isSelected": false},
    {"name": "女", "isSelected": false},
    {"name": "保密", "isSelected": false}
  ];

  List _identityLst = [
    {"name": "学生", "isSelected": false},
    {"name": "上班族", "isSelected": false},
    {"name": "其他", "isSelected": false}
  ];

  TextEditingController _nameController = TextEditingController();

  final sqlHelp = SqliteHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPersonalMsg();
  }

  @protected
  _getPersonalMsg()async{
    _nikeName = await LocalStorage.get("nikeName").then((result) {
      return result;
    });
    _avatar = await LocalStorage.get("avatar_url").then((result) {
      return result;
    });
    _sex = await LocalStorage.get("gender").then((result) {
      if(result == 'male'){
        result = "男";
      }else if(result == 'female'){
        result = "女";
      }else{
        result = "保密";
      }
      return result;
    });
    _identity = await LocalStorage.get("identity").then((result) {
      if(result == 'student'){
        result = "学生";
      }else if(result == 'office'){
        result = "上班族";
      }else{
        result = "其他";
      }
      return result;
    });
    _birthday = await LocalStorage.get("birth").then((result) {
      return result;
    });
  }

  @protected
  _updateBirthDay() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        locale: LocaleType.zh,
        currentTime: DateTime.parse(_birthday), onConfirm: (date) {
      if (mounted) {
        setState(() {
          String _year = date.year.toString();
          String _month = date.month.toString();
          String _day = date.day.toString();
          _month = (_month.length == 1) ? ('0' + _month) : _month;
          _day = (_day.length == 1) ? ('0' + _day) : _day;

          _birthday = _year + '-' + _month + '-' + _day;
//              _updateBirthDayToDB();
        });
      }
    });
  }

  @protected
  _updateGender() {
    showModalBottomSheet(
        context: context,
        backgroundColor: MyColors.white_fe,
        builder: (BuildContext context) {
          return new Container(
              padding: EdgeInsets.only(left: 18, right: 18),
              child:
                  new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 18),
                    child: Center(
                        child: Text('性别',
                            style: TextStyle(
                                color: MyColors.black_32,
                                fontSize: MyFonts.f_18)))),
                ListView.builder(
                    itemBuilder: itemBuilderSex,
                    itemCount: _sexLst.length,
                    shrinkWrap: true),
              ]));
        });
  }

  Widget itemBuilderSex(BuildContext context, int index) {
    Map _sexChose = _sexLst[index];
    return Column(children: <Widget>[
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              _sexLst.forEach((item) {
                item["isSelected"] = false;
              });
              _sex = _sexChose["name"];
              _sexChose["isSelected"] = true;
            });
            CommonUtil.closePage(context);
          },
          child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_sexChose["name"],
                        style: TextStyle(
                            color: MyColors.black_32, fontSize: MyFonts.f_18)),
                    _sexChose["isSelected"] == true
                        ? Icon(Icons.check, color: MyColors.orange_68, size: 24)
                        : Container()
                  ]))),
      SeparatorWidget()
    ]);
  }

  @protected
  _updateIdentity() {
    showModalBottomSheet(
        context: context,
        backgroundColor: MyColors.white_fe,
        builder: (BuildContext context) {
          return new Container(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: ListView.builder(
                  itemBuilder: itemBuilderIdentity,
                  itemCount: _identityLst.length,
                  shrinkWrap: true));
        });
  }

  Widget itemBuilderIdentity(BuildContext context, int index) {
    Map _identityChose = _identityLst[index];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _identityLst.forEach((item) {
                    item["isSelected"] = false;
                  });
                  _identity = _identityChose["name"];
                  _identityChose["isSelected"] = true;
                });
                CommonUtil.closePage(context);
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_identityChose["name"],
                            style: TextStyle(
                                color: MyColors.black_32,
                                fontSize: MyFonts.f_18)),
                        _identityChose["isSelected"] == true
                            ? Icon(Icons.check,
                                color: MyColors.orange_68, size: 24)
                            : Container()
                      ]))),
          SeparatorWidget()
        ]);
  }

  ///打开相机
  @protected
  _openCamera() {
    ImagePicker.pickImage(source: ImageSource.camera).then(_cropPhotoAndSave);
  }

  ///打开个人相册
  @protected
  _openGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then(_cropPhotoAndSave);
  }

  ///裁剪图片并将图片返回展示到个人信息页
  @protected
  _cropPhotoAndSave(imageFile) {
    print("路径" + imageFile.toString());
    if (imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoCrop(imageFile),
        ),
      ).then((Object result) {
        if (result != null) {
          Map<String, dynamic> map = result;
          if (mounted) {
            setState(() {
              _avatar = map['croppedFile'];
//              _avatarPath = map['avatarPath'];

//              _updateAvatarToDB();
            });
          }
        }
      });
    }
  }

  @protected
  _updateAvatar() {
    showModalBottomSheet(
        context: context,
        backgroundColor: MyColors.white_fe,
        builder: (BuildContext context) {
          return new Container(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _openCamera,
                        child: Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Text("拍照",
                                style: TextStyle(
                                    color: MyColors.black_32,
                                    fontSize: MyFonts.f_18)))),
                    SeparatorWidget(),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _openGallery,
                        child: Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Text("从相册选择",
                                style: TextStyle(
                                    color: MyColors.black_32,
                                    fontSize: MyFonts.f_18)))),
                    SeparatorWidget(),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtil.closePage(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Text("取消",
                                style: TextStyle(
                                    color: MyColors.orange_68,
                                    fontSize: MyFonts.f_18))))
                  ]));
        });
  }

  @protected
  Result resultArr = new Result();

  _updateCity() async {
    Result tempResult = await CityPickers.showCityPicker(
      locationCode: resultArr != null
          ? resultArr.areaId ?? resultArr.cityId ?? resultArr.provinceId
          : null,
      height: 300,
      context: context,
    );
    if (tempResult != null) {
      setState(() {
        resultArr = tempResult;
        _location = resultArr.provinceName +
            ' ' +
            resultArr.cityName +
            ' ' +
            resultArr.areaName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "我的",
        color: MyColors.white_fe,
        isBack: false,
        backTitle: "取消",
        rightEvent: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async{

              await sqlHelp.open();

//              sqlHelp.insert({"userId":3,"name":_nameController.text});
//              sqlHelp.delete(3);

              sqlHelp.insert({
                "userId":1
              });
              List l = await sqlHelp.queryAll();
              print(l);

//              await sqlHelp.close();
            
            
//            LocalStorage.save(BaseCommon.USER_NAME, 1);
//            print(LocalStorage.get(BaseCommon.USER_NAME));
            },
            child: Text("保存",
                style: TextStyle(
                    color: MyColors.orange_67, fontSize: MyFonts.f_16))),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.grey_f9,
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(children: <Widget>[
                SizedBox(height: 2),
                builder("头像", "116.62.141.151"+_avatar, _updateAvatar),
                SeparatorWidget(),
                builder("昵称", _nikeName, () {}),
                SizedBox(height: 12),
                builder("性别", _sex, _updateGender),
                SeparatorWidget(),
                builder("身份", _identity, _updateIdentity),
                SeparatorWidget(),
                builder("所在地", _location, _updateCity),
                SeparatorWidget(),
                builder("生日", _birthday, _updateBirthDay)
              ]))),
    );
  }

  Widget builder(String _title, String _text, Function _function) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _function,
        child: Container(
            color: MyColors.white_fe,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 18),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_title,
                          style: TextStyle(
                              fontSize: MyFonts.f_15,
                              color: MyColors.black_32)),
                      Row(children: <Widget>[
                        _title == "头像"
                            ? ClipOval(
                                child: Image.network(_text,
                                    width: 32, height: 32, fit: BoxFit.cover),
                              )
                            : _title == "昵称"?Container(
                          width: 50,
                          child: TextField(
                              controller: _nameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(7) //限制长度
                              ],
                              cursorColor: MyColors.orange_68,
                              decoration: InputDecoration(
                                hintText: _nikeName,
                                hintStyle: TextStyle(
                                  fontSize: MyFonts.f_15,
                                  color: MyColors.grey_cb,
                                ),
                                border: InputBorder.none,
                              ))
                        ):Text(_text,
                                style: TextStyle(
                                    fontSize: MyFonts.f_15,
                                    color: MyColors.grey_cb)),
                        SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          size: 24,
                          color: MyColors.grey_e2,
                        )
                      ])
                    ]))));
  }
}
