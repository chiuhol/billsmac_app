import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-4-23

class ManagerManage extends StatefulWidget {
  @override
  _ManagerManageState createState() => _ManagerManageState();
}

class _ManagerManageState extends State<ManagerManage> {
  bool _done = false;
  List _managerLst = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _jobNumController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _cleanStatus = false;
  String _query = "";
  int _pageIndex = 1;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _pageIndex = 1;
    _managerLst = [];
    _getManagers();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex++;
    _getManagers();
    _refreshController.loadComplete();
  }

  @protected
  _getManagers() async {
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          queryParameters: {"q": _query, "page": _pageIndex, "per_Page": 10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getManagers());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _managerLst.addAll(response.data["data"]["managers"]);
            _done = true;
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @protected
  _updateManagers(id, status) async {
    try {
      BaseOptions options = BaseOptions(method: "patch");
      var dio = new Dio(options);
      var response =
          await dio.patch(Address.updateManagers(id), data: {"status": status});
      print(response.data.toString());
      if (response.data["status"] == 200) {}
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getManagers();
  }

  _addManager() async {
    try {
      BaseOptions options = BaseOptions(method: "post");
      var dio = new Dio(options);
      var response = await dio.post(Address.addManagers(), data: {
        "jobNum": _jobNumController.text,
        "account": _accountController.text,
        "password": _passwordController.text
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _managerLst.add(response.data["data"]["manager"]);
          });
        }
      }
    } catch (err) {
      print(err.toString());
      if(err.toString() == "DioError [DioErrorType.RESPONSE]: Http status error [409]"){
        CommonUtil.showMyToast("该账号已存在");
        return;
      }
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  _addManagerDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        child: new SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Container(
                margin: EdgeInsets.only(left: 80),
                child: Text('添加管理员',
                    style: TextStyle(
                        color: MyColors.black_33, fontSize: MyFonts.f_16))),
            contentPadding: const EdgeInsets.all(10.0),
            children: <Widget>[
              SeparatorWidget(),
              SizedBox(height: 13.5),
              Column(children: <Widget>[
                Row(children: <Widget>[
                  Text("工号：", style: TextStyle(fontSize: MyFonts.f_16)),
                  Expanded(
                      child: TextField(
                          maxLines: 1,
                          controller: _jobNumController,
                          keyboardType: TextInputType.phone,
                          cursorColor: MyColors.green_8d,
                          style: TextStyle(
                              color: MyColors.green_8d, fontSize: MyFonts.f_18),
                          decoration: InputDecoration(
                              hintText: '请输入工号',
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_16,
                                color: MyColors.red_5c,
                              ),
                              border: InputBorder.none)))
                ]),
                Padding(
                    padding: EdgeInsets.only(top: 18, bottom: 18),
                    child: Row(children: <Widget>[
                      Text("账号：", style: TextStyle(fontSize: MyFonts.f_16)),
                      Expanded(
                          child: TextField(
                              maxLines: 1,
                              controller: _accountController,
                              keyboardType: TextInputType.phone,
                              cursorColor: MyColors.green_8d,
                              style: TextStyle(
                                  color: MyColors.green_8d,
                                  fontSize: MyFonts.f_18),
                              decoration: InputDecoration(
                                  hintText: '请输入账号',
                                  hintStyle: TextStyle(
                                    fontSize: MyFonts.f_16,
                                    color: MyColors.red_5c,
                                  ),
                                  border: InputBorder.none)))
                    ])),
                Row(children: <Widget>[
                  Text("密码：", style: TextStyle(fontSize: MyFonts.f_16)),
                  Expanded(
                      child: TextField(
                          maxLines: 1,
                          controller: _passwordController,
                          cursorColor: MyColors.green_8d,
                          style: TextStyle(
                              color: MyColors.green_8d, fontSize: MyFonts.f_18),
                          decoration: InputDecoration(
                              hintText: '请输入密码',
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_16,
                                color: MyColors.red_5c,
                              ),
                              border: InputBorder.none)))
                ])
              ]),
              SizedBox(height: 13.5),
              SeparatorWidget(),
              Container(
                  height: 45,
                  child: RaisedButton(
                      color: MyColors.white_ff,
                      elevation: 0,
                      splashColor: MyColors.white_ff,
                      child: Text('添加',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyColors.green_8d,
                              fontSize: MyFonts.f_14)),
                      onPressed: () {
                        if (_jobNumController.text == '') {
                          CommonUtil.showMyToast("请输入工号");
                          return;
                        }
                        if (_accountController.text == '') {
                          CommonUtil.showMyToast("请输入账号");
                          return;
                        }
                        if (_passwordController.text == '') {
                          CommonUtil.showMyToast("请输入密码");
                          return;
                        }
                        if (_jobNumController.text.length > 6) {
                          CommonUtil.showMyToast("工号长度规定为1-6");
                          return;
                        }
                        if (_accountController.text.length > 12) {
                          CommonUtil.showMyToast("账号长度规定为1-12");
                          return;
                        }
                        if (_passwordController.text.length < 6 ||
                            _passwordController.text.length > 12) {
                          CommonUtil.showMyToast("密码长度规定为6-12");
                          return;
                        }
                        Navigator.pop(context);
                        _addManager();
                      }))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(children: <Widget>[
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _addManagerDialog();
                  },
                  child: Icon(Icons.add)),
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
                                        hintText: '请输入搜索内容(工号)',
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
                    if (mounted) {
                      setState(() {
                        _managerLst = [];
                        _query = _searchController.text;
                      });
                    }
                    _getManagers();
                  },
                  child: Text('搜索'))
            ])),
        _done == false
            ? Center(child: Text("加载中......"))
            : _managerLst.length == 0
                ? Center(child: Text("暂无管理员信息~"))
                : Container(
                    width: double.infinity,
                    height: 600,
                    child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("上拉加载");
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("加载失败!请再试试!");
                          } else {
                            body = Text("没有更多数据了");
                          }
                          return Container(
                              height: 55, child: Center(child: body));
                        }),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: itemBuilder,
                            itemCount: _managerLst.length,
                            shrinkWrap: true)))
      ]))),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _manager = _managerLst[index];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Container(
          color: MyColors.white,
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("工号", style: TextStyle(fontSize: MyFonts.f_16)),
                      Text(_manager["jobNum"] ?? "暂无内容",
                          style: TextStyle(fontSize: MyFonts.f_16))
                    ])),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("账号",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: MyFonts.f_16)),
                  Text(_manager["account"] ?? "",
                      style: TextStyle(fontSize: MyFonts.f_16))
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("状态", style: TextStyle(fontSize: MyFonts.f_16)),
                  Switch(
                      activeColor: MyColors.green_8d,
                      value: _manager["status"] ?? false,
                      onChanged: (value) {
                        setState(() {
                          _updateManagers(_manager["_id"], value);
                          _manager["status"] = value;
                        });
                      })
                ]),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("创建时间", style: TextStyle(fontSize: MyFonts.f_16)),
                      Text(
                          _manager["createdAt"].toString().substring(0, 10) ??
                              "",
                          style: TextStyle(fontSize: MyFonts.f_16))
                    ]))
          ])),
      SizedBox(height: 10)
    ]);
  }
}
