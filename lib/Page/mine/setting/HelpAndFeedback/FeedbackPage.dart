import 'package:billsmac_app/Common/CommonInsert.dart';

import 'FeedbackHistoryPage.dart';

///Author:chiuhol
///2020-2-24

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _inputController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String _type = '';

  @protected
  _submit(){
    if(_type == ''){
      CommonUtil.showMyToast('请选择反馈类型');
      return;
    }
    if(_inputController.text == ''){
      CommonUtil.showMyToast('请输入反馈内容');
      return;
    }
    if(_phoneController.text == ''){
      CommonUtil.showMyToast('请输入手机号或qq号');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "用户反馈",
            color: MyColors.white_fe,
            isBack: true,
            rightEvent: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  CommonUtil.openPage(context, FeedbackHistoryPage());
                },
                child: Text('反馈历史',
                    style: TextStyle(
                        color: MyColors.black_32, fontSize: MyFonts.f_14))),
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28)),
        bottomSheet: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _submit,
          child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.orange_76, MyColors.orange_62],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
              child: Center(
                  child: Text('提交',
                      style: TextStyle(
                          color: MyColors.white_fe, fontSize: MyFonts.f_16))))
        ),
        body: Container(
            color: MyColors.grey_f6,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      builder('反馈类型'),
                      typeWidget(),
                      builder('反馈内容'),
                      contentWidget(),
                      builder('联系方式'),
                      phoneWidget()
                    ]))));
  }

  Widget phoneWidget() {
    return Container(
        width: double.infinity,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
        child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            cursorColor: MyColors.orange_68,
            decoration: InputDecoration(
              hintText: '请输入手机号或qq号',
              hintStyle:
                  TextStyle(fontSize: MyFonts.f_15, color: MyColors.grey_cb),
              border: InputBorder.none,
            )));
  }

  Widget contentWidget() {
    return Container(
        width: double.infinity,
        height: 200,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: TextField(
            controller: _inputController,
            maxLines: 10,
            maxLength: 300,
            cursorColor: MyColors.orange_68,
            decoration: InputDecoration(
              hintText: '请输入反馈内容',
              hintStyle: TextStyle(
                fontSize: MyFonts.f_15,
                color: MyColors.grey_cb,
              ),
              border: InputBorder.none,
            )));
  }

  List _typeLst = [
    {"type": "功能建议", "isSelected": false},
    {"type": "性能问题", "isSelected": false},
    {"type": "其他", "isSelected": false}
  ];

  Widget typeWidget() {
    return Container(
        width: double.infinity,
        height: 95,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //横轴元素个数
                crossAxisCount: 4,
                //纵轴间距
                mainAxisSpacing: 10.0,
                //横轴间距
                crossAxisSpacing: 10.0,
                //子组件宽高长度比例
                childAspectRatio: 2),
            itemBuilder: itembuilder,
            itemCount: _typeLst.length));
  }

  Widget itembuilder(BuildContext context, int index) {
    Map _type = _typeLst[index];
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!_type["isSelected"]) {
            setState(() {
              _typeLst.forEach((item) {
                item["isSelected"] = false;
              });
              _type["isSelected"] = true;
            });
          }
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: _type["isSelected"] == true
                        ? MyColors.blue_e9
                        : MyColors.black_32),
                color: MyColors.white_fe),
            child: Center(
                child: Text(_type["type"],
                    style: TextStyle(
                        color: _type["isSelected"] == true
                            ? MyColors.blue_e9
                            : MyColors.black_32,
                        fontSize: MyFonts.f_16)))));
  }

  Widget builder(String text) {
    return Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 12),
        child: Text(text,
            textAlign: TextAlign.left,
            style:
                TextStyle(color: MyColors.black_32, fontSize: MyFonts.f_16)));
  }
}
