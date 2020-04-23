import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:dio/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-4-22

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List _userLst = [];
  int _pageIndex = 1;

  bool done = false;
  bool _cleanStatus = false;

  TextEditingController _searchController = TextEditingController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _pageIndex = 1;
    _userLst = [];
    _getUsers("");
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex++;
    _getUsers("");
    _refreshController.loadComplete();
  }

  @protected
  _getUsers(q) async {
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          queryParameters: {"q": q, "page": _pageIndex, "per_Page": 10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getUsers());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _userLst = [];
            _userLst.addAll(response.data["data"]["user"]);
            _userLst.forEach((items) {
              items.addAll({"isExpanded": false});
            });
            done = true;
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUsers("");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Row(children: <Widget>[
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: MyColors.grey_f5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: Icon(
                                  IconData(0xe63a, fontFamily: 'MyIcons'),
                                  size: 18,
                                  color: MyColors.red_5c)),
                          Expanded(
                              child: TextField(
                                  maxLines: 1,
                                  controller: _searchController,
                                  cursorColor: MyColors.green_8d,
                                  onChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        if (value != '') {
                                          _cleanStatus = true;
                                        } else {
                                          _cleanStatus = false;
                                        }
                                      });
                                    }
                                  },
                                  style: TextStyle(
                                      color: MyColors.green_8d,
                                      fontSize: MyFonts.f_18),
                                  decoration: InputDecoration(
                                      hintText: '请输入搜索内容(手机号)',
                                      hintStyle: TextStyle(
                                        fontSize: MyFonts.f_16,
                                        color: MyColors.red_5c,
                                      ),
                                      border: InputBorder.none))),
                          _cleanStatus == true
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        _cleanStatus = false;
                                        _searchController.clear();
                                      });
                                    }
                                  },
                                  child: Icon(Icons.clear,
                                      color: MyColors.red_5c, size: 24))
                              : Container(),
                          SizedBox(width: 10)
                        ]))),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _getUsers(_searchController.text);
                },
                child: Text('搜索'))
          ])),
      userWidget()
    ])));
  }

  Widget userWidget() {
    if (done) {
      if(_userLst.length != 0){
        return ExpansionPanelList(
          //开关动画时长
          animationDuration: Duration(milliseconds: 500),
          //开关回调
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              _userLst[panelIndex]["isExpanded"] =
              !_userLst[panelIndex]["isExpanded"];
            });
          },
          //内容区
          children: _userLst.map<ExpansionPanel>((user) {
            return new ExpansionPanel(
              //标题
              headerBuilder: (context, isExpanded) {
                return new ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: new Text(user["phone"] ?? ""),
                );
              },
              //展开内容
              body: Column(children: <Widget>[
                ListTile(
                  leading: Text("昵称"),
                  title: new Text(user["nikeName"] ?? "未设置"),
                ),
                ListTile(
                  leading: Text("性别"),
                  title: new Text(user["gender"] ?? "未设置"),
                ),
                ListTile(
                  leading: Text("生日"),
                  title: new Text(user["birth"] ?? "未设置"),
                ),
                ListTile(
                  leading: Text("身份"),
                  title: new Text(user["identity"] ?? "未设置"),
                ),
                ListTile(
                  leading: Text("位置"),
                  title: new Text(user["location"] ?? "未设置"),
                ),
                ListTile(
                  leading: Text("创建时间"),
                  title: new Text(user["createdAt"].toString().substring(0,19) ?? ""),
                ),
                ListTile(
                  leading: Text("更新时间"),
                  title: new Text(user["updatedAt"].toString().substring(0,19) ?? ""),
                ),
                RaisedButton(
                  child: new Text("删除用户"),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () {},
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.white,
                  disabledElevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)), //圆角大小
                )
              ]),
              //是否展开
              isExpanded: user["isExpanded"],
            );
          }).toList(),
        );
      }else{
        return Center(child: Text("暂无搜索内容~"));
      }
    } else {
      return Center(child: Text("加载中......"));
    }
  }
}
