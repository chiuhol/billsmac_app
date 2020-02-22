import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';

///Author:chiuhol
///2020-2-22

class UpdateMsgPage extends StatefulWidget {
  final String title;
  final String content;
  UpdateMsgPage({this.title,this.content});
  @override
  _UpdateMsgPageState createState() => _UpdateMsgPageState();
}

class _UpdateMsgPageState extends State<UpdateMsgPage> {
  TextEditingController _updateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _updateController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.title,
        color: MyColors.white_fe,
        isBack: false,
        backTitle: "取消",
        rightEvent: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pop(_updateController.text);
            },
            child: Text("保存",
                style: TextStyle(
                    color: MyColors.orange_67, fontSize: MyFonts.f_16)))
      ),
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            height: 50,
            color: MyColors.white_fe,
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: 100,
                      child: TextField(
                          controller: _updateController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(7)
                            //限制长度
                          ],
                          autofocus: true,
                          cursorColor: MyColors.orange_68,
                          decoration: InputDecoration(
                            hintText: widget.title,
                            hintStyle: TextStyle(
                              fontSize: MyFonts.f_15,
                              color: MyColors.grey_cb,
                            ),
                            border: InputBorder.none,
                          ))),
                  SizedBox(width: 8),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          _updateController.text = '';
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        color: MyColors.grey_cb,
                        size: 20
                      ))
                ]))
      )
    );
  }
}
