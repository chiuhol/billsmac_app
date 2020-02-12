import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:gesture_password/gesture_password.dart';
import 'package:gesture_password/mini_gesture_password.dart';

///Author:chiuhol
///2020-2-8

class SetGesturePasswordPage extends StatefulWidget {
  @override
  _SetGesturePasswordPageState createState() => _SetGesturePasswordPageState();
}

class _SetGesturePasswordPageState extends State<SetGesturePasswordPage> {
  GlobalKey miniGesturePassword = new GlobalKey();

  GlobalKey scaffoldState = new GlobalKey();

  String _tips = "绘制解锁图案";
  String _firstPass = "";
  String _secondOPass = "";
  int _times = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [MyColors.orange_76, MyColors.orange_62],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 40, left: 12),
                  child: Row(children: <Widget>[
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtil.closePage(context);
                        },
                        child: Icon(Icons.keyboard_arrow_left,
                            size: 24, color: MyColors.white_fe)),
                    Padding(
                        padding: EdgeInsets.only(left: 130),
                        child: Text("设置手势密码",
                            style: TextStyle(
                                color: MyColors.white_fe,
                                fontSize: MyFonts.f_16)))
                  ])),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: MyColors.white_fe, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: ClipOval(
                            child: Image.network(
                                'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1379686624,47059782&fm=26&gp=0.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover)),
                      ))),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: Text(_tips,
                          style: TextStyle(
                              color: MyColors.white_fe,
                              fontSize: MyFonts.f_15)))),
              new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return new Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: new GesturePassword(
                      attribute: ItemAttribute.normalAttribute,
                      successCallback: (s) {
                        print("successCallback$s");
                        if(_times == 0 || _times == 1){
                          _times++;
                        }
                        if (_times == 1) {
                          setState(() {
                            _firstPass = s;
                            _tips = "再次绘制图案";
                          });
                        } else {
                          setState(() {
                            _secondOPass = s;
                          });
                        }
                        print(_firstPass);
                        print(_secondOPass);
                        if (_times == 2) {
                          if (_firstPass != _secondOPass) {
                            _tips = "与上一次绘制不一致，请重新绘制";
                          } else {
                            _tips = "手势密码绘制成功";
                            CommonUtil.closePage(context);
                          }
                        }
                      },
                      failCallback: () async {
                        setState(() {
                          _tips = "请至少连接4个节点";
                        });
                        await Future.delayed(Duration(milliseconds: 1000));
                        setState(() {
                          _tips = "绘制解锁图案";
                        });
                      },
                      selectedCallback: (str) {
                        print(str);
                      },
                    ),
                  );
                },
              )
            ])));
  }
}
