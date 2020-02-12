import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/util/ServiceLocator.dart';
import 'package:billsmac_app/Common/util/TelAndSmsService.dart';

class SubprojectWidget extends StatelessWidget {
  final int icon;
  final Widget rout;
  final String title, subTitle;
  final Color iconColor;

  SubprojectWidget({this.icon, this.rout, this.title, this.subTitle, this.iconColor = MyColors.orange_81});

  final TelAndSmsService _service = locator<TelAndSmsService>();
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if(title == "联系我们"){
            _service.call(subTitle);
            return;
          }
          CommonUtil.openPage(context, this.rout);
        },
        child: Container(
          color: MyColors.white_fe,
            padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 18),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(IconData(this.icon, fontFamily: 'MyIcons'),
                        size: 24, color: iconColor),
                    SizedBox(width: 8),
                    Text(this.title,
                        style: TextStyle(
                            color: MyColors.black_32,
                            fontSize: 15,
                            fontWeight: FontWeight.bold))
                  ]),
                  Row(children: <Widget>[
                    Text(this.subTitle ?? "",
                        style:
                            TextStyle(color: MyColors.grey_e2, fontSize: 14)),
                    Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: MyColors.grey_e2,
                    )
                  ])
                ])));
  }
}
