import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

///Author:chiuhol
///2020-2-9

class CalendarMainPage extends StatefulWidget {
  @override
  _CalendarMainPageState createState() => _CalendarMainPageState();
}

class _CalendarMainPageState extends State<CalendarMainPage> {
  String _title = "";

  CalendarController controller= new CalendarController(
      minYear: 2018,
      minYearMonth: 1,
      maxYear: 2020,
      maxYearMonth: 12,
      showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    CalendarViewWidget calendar= CalendarViewWidget(
      calendarController: controller,
      boxDecoration: BoxDecoration(
        color: MyColors.white_fe,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      margin: EdgeInsets.only(left: 18,right: 18,top: 18),
    );

    return Scaffold(
      appBar: MyAppBar(
          title: _title,
          color: MyColors.white_fe,
          isBack: true,
          backIcon: Icon(Icons.keyboard_arrow_left,
              color: MyColors.black_32, size: 28)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.grey_f9,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: <Widget>[
              calendar
            ]
          )
        )
      )
    );
  }
}
