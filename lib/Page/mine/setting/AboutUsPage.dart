import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:dio/dio.dart';

///Author:chiuhol
///2020-2-8

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String _qqGroup = '暂无';
  String _wechat = '暂无';
  String _emailAddress = '暂无';

  @protected
  _getMsg()async{
    try {
      BaseOptions options = BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio.get(Address.getAboutUs());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _qqGroup = response.data["data"]["aboutUs"][0]["qqGroup"]??"暂无";
            _wechat = response.data["data"]["aboutUs"][0]["officialAccount"]??"暂无";
            _emailAddress = response.data["data"]["aboutUs"][0]["emailAddress"]??"暂无";
          });
        }
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getMsg();
  }

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 30,bottom: 30),
                      child: Center(
                          child: Text(
                              "每日记账",
                              style: TextStyle(
                                  fontSize: MyFonts.f_22,
                                  color: MyColors.orange_68
                              )
                          )
                      )
                  ),
                  SeparatorWidget(),
                  rowWidget("QQ群", _qqGroup),
                  SeparatorWidget(),
                  rowWidget("微信公众号", _wechat),
                  SeparatorWidget(),
                  rowWidget("给我们写信", _emailAddress),
                  SeparatorWidget()
                ]
            )
        )
      )
    );
  }

  Widget rowWidget(String title,String content){
    return Padding(
      padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(
                  fontSize: MyFonts.f_16,
                  color: MyColors.black_1a
              )
          ),
          Text(
              content,
              style: TextStyle(
                  fontSize: MyFonts.f_16,
                  color: MyColors.black_1a
              )
          )
        ]
      )
    );
  }
}
