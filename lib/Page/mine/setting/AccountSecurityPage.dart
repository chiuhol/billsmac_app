import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Widget/SubprojectWidget.dart';

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
                      subTitle: _phone),
                  SeparatorWidget(),
                  SubprojectWidget(
                      title: '修改密码', icon: 0xe626, iconColor: MyColors.grey_e4),
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
                  Container(
                      color: MyColors.white_fe,
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: Center(
                          child: Text("注销账号",
                              style: TextStyle(
                                  color: MyColors.red_34,
                                  fontSize: MyFonts.f_15))))
                ]))));
  }
}
