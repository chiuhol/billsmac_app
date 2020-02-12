import 'package:billsmac_app/Common/CommonInsert.dart';

///Author:chiuhol
///2020-2-8

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "关于我们",
        isBack: true,
        backIcon: Icon(Icons.keyboard_arrow_left,
            color: MyColors.black_32, size: 28),
        color: MyColors.white_fe,
      ),
    );
  }
}
