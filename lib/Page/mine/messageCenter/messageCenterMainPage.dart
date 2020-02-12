import 'package:billsmac_app/Common/CommonInsert.dart';

///Author；chiuhol
///2020-2-8

class MessageCenterMainPage extends StatefulWidget {
  @override
  _MessageCenterMainPageState createState() => _MessageCenterMainPageState();
}

class _MessageCenterMainPageState extends State<MessageCenterMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "提醒",
        isBack: true,
        backIcon: Icon(Icons.keyboard_arrow_left,
            color: MyColors.black_32, size: 28),
        color: MyColors.white_fe,
      ),
    );
  }
}
