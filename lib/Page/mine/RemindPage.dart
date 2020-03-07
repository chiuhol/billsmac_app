import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

///Author:chiuhol
///2020-2-8

class RemindPage extends StatefulWidget {
  @override
  _RemindPageState createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  String _remindTime = "";
  String _remindPeriod = "";

  bool switchValue = false;

  List _periodLst = [
    {"name": "每周一", "isSelected": false},
    {"name": "每周二", "isSelected": false},
    {"name": "每周三", "isSelected": false},
    {"name": "每周四", "isSelected": false},
    {"name": "每周五", "isSelected": false},
    {"name": "每周六", "isSelected": false},
    {"name": "每周日", "isSelected": false},
  ];

  @protected
  _setRemindTime() {
    DatePicker.showDatePicker(
      context,
      initialDateTime: DateTime.parse(DateTime.now().toString()),
      dateFormat: 'H时:mm分',
      pickerMode: DateTimePickerMode.time,
      // show TimePicker
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('保存',
            style:
                TextStyle(color: MyColors.orange_68, fontSize: MyFonts.f_16)),
        cancel: Text('取消',
            style: TextStyle(color: MyColors.grey_cb, fontSize: MyFonts.f_16)),
      ),
      onCancel: () {
        debugPrint('onCancel');
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _remindTime =
              '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        });
      },
    );
  }

  @protected
  _setPeriodTime() {
    showModalBottomSheet(
        context: context,
        backgroundColor: MyColors.white_fe,
        builder: (BuildContext context) {
          return new Container(
              padding: EdgeInsets.only(left: 18, right: 18),
              child:
                  new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: 8, bottom: 18, left: 18, right: 18),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                CommonUtil.closePage(context);
                              },
                              child: Text('取消',
                                  style: TextStyle(
                                      color: MyColors.grey_cb,
                                      fontSize: MyFonts.f_16))),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                List _period = [];
                                _periodLst.forEach((items) {
                                  if (items["isSelected"]) {
                                    _period.add(items["name"]);
                                  }
                                });
                                if (_period.length == 7) {
                                  setState(() {
                                    _remindPeriod = "每天";
                                  });
                                } else {
                                  setState(() {
                                    _remindPeriod =
                                        _period.join(",").replaceAll("每", "");
                                  });
                                }
                                CommonUtil.closePage(context);
                              },
                              child: Text('保存',
                                  style: TextStyle(
                                      color: MyColors.orange_68,
                                      fontSize: MyFonts.f_16)))
                        ])),
                Container(
                    height: 300, child: ModalBottomSheet(countries: _periodLst))
              ]));
        });
  }

  @protected
  _savePersonalMsg() async {
    String _userId = await LocalStorage.get("_id").then((result) {
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
      var response = await dio.patch(Address.updatePersonalMsg(_userId),
          data: {"remindTime": _remindTime});
      print(response.data.toString());
      if (response.data["status"] == 200) {
        LocalStorage.save("remindTime", _remindTime);
        Navigator.of(context).pop("success");
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _getPersonalMsg() async {
    String _time = await LocalStorage.get("remindTime").then((result) {
      return result;
    });
    bool _isRemind = await LocalStorage.getBool("isRemind").then((result) {
      return result;
    });
    print(_isRemind);
    String _period = await LocalStorage.get("remindPeriod").then((result) {
      return result;
    });
    if (mounted) {
      setState(() {
        _remindTime = _time;
        switchValue = _isRemind ?? false;
        _remindPeriod = _period;
        List _a =
            _remindPeriod.replaceAll("周", "").replaceAll("，", "").split(",");
        _periodLst.forEach((items) {
          for (int i = 0; i < _a.length; i++) {
            if (items["name"].toString().contains(_a[i])) {
              items["isSelected"] = true;
            }
          }
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPersonalMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "记账提醒",
          isBack: true,
          backEvent: () {
            if (switchValue) {
              LocalStorage.save("isRemind", switchValue);
              LocalStorage.save("remindTime", _remindTime);
              LocalStorage.save("remindPeriod", _remindPeriod);
              _savePersonalMsg();
            }
          },
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
                  Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 24, top: 10, bottom: 10),
                      color: MyColors.white_fe,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("记账提醒",
                                style: TextStyle(
                                    color: MyColors.black_32,
                                    fontSize: MyFonts.f_15)),
                            Switch(
                                activeColor: MyColors.orange_68,
                                value: switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                })
                          ])),
                  SeparatorWidget(),
                  builder("提醒时间", _remindTime ?? "19:30", _setRemindTime),
                  SeparatorWidget(),
                  builder("重复周期", _remindPeriod ?? "每天", _setPeriodTime)
                ]))));
  }

  Widget builder(String title, String subTitle, Function function) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (switchValue) {
            function();
          }
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
                            color: switchValue == true
                                ? MyColors.black_32
                                : MyColors.grey_e2,
                            fontSize: MyFonts.f_15)),
                    Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: MyColors.grey_e2,
                    )
                  ])
                ])));
  }
}

class ModalBottomSheet extends StatefulWidget {
  ModalBottomSheet({
    Key key,
    this.countries,
  }) : super(key: key);

  final List<dynamic> countries;

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: itemBuilderPeriod,
        itemCount: widget.countries.length,
        shrinkWrap: true);
  }

  Widget itemBuilderPeriod(BuildContext context, int index) {
    Map _period = widget.countries[index];
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            if (!_period["isSelected"]) {
              _period["isSelected"] = true;
            } else {
              _period["isSelected"] = false;
            }
          });
        },
        child: Container(
            color: MyColors.white_fe,
            padding: EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_period["name"],
                      style: TextStyle(
                          color: MyColors.black_32, fontSize: MyFonts.f_15)),
                  Icon(
                      IconData(_period["isSelected"] == true ? 0xe630 : 0xe628,
                          fontFamily: 'MyIcons'),
                      size: 24,
                      color: _period["isSelected"] == true
                          ? MyColors.orange_68
                          : MyColors.grey_f6),
                ])));
  }
}
