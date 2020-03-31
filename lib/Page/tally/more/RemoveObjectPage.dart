import 'package:billsmac_app/Common/CommonInsert.dart';

///Author:chiuhol
///2020-3-9

class RemoveObjectPage extends StatefulWidget {
  final List objectLst;

  RemoveObjectPage({this.objectLst});

  @override
  _RemoveObjectPageState createState() => _RemoveObjectPageState();
}

class _RemoveObjectPageState extends State<RemoveObjectPage> {
  List _objects = [];

  int _count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _objects = widget.objectLst;
    _objects.forEach((items) {
      items.addAll({"isSelect": false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "删除成员",
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28),
            color: MyColors.white_fe,
            rightEvent: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Text("删除"+(_count == 0?"":"($_count)"),
                    style: TextStyle(
                        color: MyColors.red_5c, fontSize: MyFonts.f_16)))),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.white_fe,
            child: ListView.builder(
                itemBuilder: itemBuilder,
                itemCount: _objects.length,
                shrinkWrap: true)));
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _object = _objects[index];
    return CheckboxListTile(
      activeColor: MyColors.orange_68,
      secondary: ClipOval(
          child: Image.network(_object["avatar"] ?? "",
              width: 35, height: 35, fit: BoxFit.cover)),
      title: Text(_object["nikeName"] ?? "",
          style: TextStyle(
              color: MyColors.black_32, fontSize: MyFonts.f_14)),
      value: _object["isSelect"],
      onChanged: (bool value) {
        setState(() {
          if(value){
            _object["isSelect"] = !_object["isSelect"];
            _count++;
          }else{
            _object["isSelect"] = !_object["isSelect"];
            _count--;
          }
        });
      }
    );
  }
}
