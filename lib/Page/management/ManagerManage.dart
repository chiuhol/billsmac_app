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
  _updateManagers(id,status) async {
    try {
      BaseOptions options = BaseOptions(
          method: "patch");
      var dio = new Dio(options);
      var response = await dio.patch(Address.updateManagers(id),data: {
        "status":status
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
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
                            if(mounted){
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

  Widget itemBuilder(BuildContext context,int index){
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
                  Text("状态",
                      style: TextStyle(fontSize: MyFonts.f_16)),
                  Switch(
                      activeColor: MyColors.green_8d,
                      value: _manager["status"]??false,
                      onChanged: (value) {
                        setState(() {
                          _updateManagers(_manager["_id"],value);
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
