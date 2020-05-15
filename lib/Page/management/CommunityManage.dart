import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Page/community/DetailPage.dart';
import 'package:billsmac_app/Widget/photo_crop.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-4-23

class CommunityManage extends StatefulWidget {
  @override
  _CommunityManageState createState() => _CommunityManageState();
}

class _CommunityManageState extends State<CommunityManage> {
  List _articleLst = [];

  int _pageIndex = 1;
  String _query = "";
  bool _done = false;

  String _thumbnail = "";//文章缩略图URL

  TextEditingController _searchController = TextEditingController();
  bool _cleanStatus = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _pageIndex = 1;
    _articleLst = [];
    _getArticles();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex++;
    _getArticles();
    _refreshController.loadComplete();
  }

  @protected
  _getArticles() async {
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          queryParameters: {"q": _query, "page": _pageIndex, "per_Page": 10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getAllArticles());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _articleLst.addAll(response.data["data"]["acticle"]);
            _done = true;
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @protected
  _updateArticle(String id,Map msg,bool isUpdate,bool isRecommend)async{
    try {
      BaseOptions options = BaseOptions(
          method: "patch");
      var dio = new Dio(options);
      var response = await dio.patch(Address.updateArticles(id),data: msg);
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            if(isUpdate){
              CommonUtil.showMyToast("更新成功");
              _articleLst.forEach((items){
                if(items["_id"] == id){
                  if(isRecommend){
                    items["recommend"] = !items["recommend"];
                  }else{
                    items["title"] = msg["title"];
                    items["title"] = msg["title"];
                    items["content"] = msg["content"];
                    items["thumbnail"] = msg["thumbnail"];
                  }
                }
              });
            }
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

    _getArticles();
  }

  //新建社区文章
  _newArticle(msg)async{
    try {
      BaseOptions options = BaseOptions(
          method: "post");
      var dio = new Dio(options);
      var response = await dio.post(Address.newArticles(),data: msg);
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            CommonUtil.showMyToast("发布成功");
            _articleLst.add(response.data["data"]["acticle"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();

  bool updateStatus = false;
  @protected
  _addArticle(msg,bool updateStatus) {
    if(msg != "thumbnail"){
      _contentController.clear();
      _titleController.clear();
      _subTitleController.clear();
    }
    showModalBottomSheet(
        backgroundColor: MyColors.white_fe,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context,state){
              return Stack(children: <Widget>[
                Container(
                    height: 15, width: double.infinity, color: Colors.black54),
                Container(
                    child: bottomSheet(msg,_contentController,_titleController,_subTitleController),
                    decoration: BoxDecoration(
                        color: MyColors.white_fe,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))))
              ]);
            },
          );
        }).then((value) {
      if (value != null) {
        Map msg = {
          "title":value["title"],
          "subTitle":value["subTitle"],
          "content":value["content"],
          "thumbnail":_thumbnail
        };
        if(value["type"] == "发布"){
          print("发布");
          _newArticle(msg);
        }else{
          print("更新");
          _updateArticle(value["id"], msg,true,false);
        }
      }
    });
  }

  Widget bottomSheet(msg,TextEditingController _contentController,TextEditingController _titleController, TextEditingController _subTitleController) {
    String _title = "新建社区文章";
    String _action = "发布";
    if(updateStatus){
      _contentController.text = res["content"];
      _titleController.text = res["title"];
      _subTitleController.text = res["subTitle"];
      _title = "修改社区文章";
      _action = "修改";
    }
    return Padding(
        padding: EdgeInsets.only(top: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 18, left: 18, right: 18),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtil.closePage(context);
                        },
                        child: Text('取消',
                            style: TextStyle(
                                color: MyColors.red_34,
                                fontSize: MyFonts.f_16))),
                    Text(_title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: MyColors.black_1a,
                            fontSize: MyFonts.f_16)),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (_titleController.text == '') {
                            CommonUtil.showMyToast("请输入文章标题");
                            return;
                          }
                          if (_contentController.text == '') {
                            CommonUtil.showMyToast("请输入文章内容");
                            return;
                          }
                          Navigator.of(context).pop({
                            "type":updateStatus == false?"发布":"修改",
                            "id":updateStatus == false?"":res["_id"],
                            "title":_titleController.text,
                            "subTitle":_subTitleController.text,
                            "content":_contentController.text,
                          });
                        },
                        child: Text(_action,
                            style: TextStyle(
                                color: MyColors.blue_f6,
                                fontSize: MyFonts.f_16)))
                  ])),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 18),
              child: Text("Tips：文章内容格式为html格式~",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: MyColors.black_1a,
                      fontSize: MyFonts.f_14))),
          Container(width: double.infinity, height: 8, color: MyColors.grey_f6),
          SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 18, right: 18),
                        child: TextField(
                            controller: _titleController,
                            maxLines: 2,
                            maxLength: 20,
                            cursorColor: MyColors.orange_68,
                            decoration: InputDecoration(
                              hintText: "请输入文章标题",
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_15,
                                color: MyColors.grey_cb,
                              ),
                              border: InputBorder.none,
                            ))
                    ),
                    Container(width: double.infinity, height: 3, color: MyColors.grey_f6),
                    Padding(
                        padding: EdgeInsets.only(left: 18, right: 18),
                        child: TextField(
                            controller: _subTitleController,
                            maxLines: 2,
                            maxLength: 20,
                            cursorColor: MyColors.orange_68,
                            decoration: InputDecoration(
                              hintText: "请输入文章副标题（可空）",
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_15,
                                color: MyColors.grey_cb,
                              ),
                              border: InputBorder.none,
                            ))
                    ),
                    Container(width: double.infinity, height: 3, color: MyColors.grey_f6),
                    Padding(
                        padding: EdgeInsets.only(left: 18, right: 18),
                        child: TextField(
                            controller: _contentController,
                            maxLines: 6,
                            maxLength: 300,
                            cursorColor: MyColors.orange_68,
                            decoration: InputDecoration(
                              hintText: "请输入文章内容",
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_15,
                                color: MyColors.grey_cb,
                              ),
                              border: InputBorder.none,
                            ))
                    ),
                    Container(width: double.infinity, height: 3, color: MyColors.grey_f6),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          _openGallery();
                        },
                        child: Container(
                            padding: EdgeInsets.only(top: 20),
                            margin: EdgeInsets.only(top: 20,left: 20),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: MyColors.orange_68,width: 1)
                            ),
                            child: _thumbnail != ""?Image.network("http://$_thumbnail",fit: BoxFit.fill):Center(
                                child: Column(
                                    children: <Widget>[
                                      Icon(Icons.add,size: 24,color: MyColors.grey_99),
                                      Text(
                                          "点击上传图片",style: TextStyle(
                                          color: MyColors.grey_99,
                                          fontSize: MyFonts.f_12
                                      )
                                      )
                                    ]
                                )
                            ))
                    )
                  ]
              )
          )
        ]));
  }

  ///打开个人相册
  @protected
  _openGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then(_cropPhotoAndSave);
  }

  ///裁剪图片并将图片返回展示到个人信息页
  @protected
  _cropPhotoAndSave(imageFile) {
    print("路径" + imageFile.toString());
    if (imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoCrop(imageFile),
        ),
      ).then((Object result) {
        if (result != null) {
          Map<String, dynamic> map = result;
          if (mounted) {
            setState(() {
              String _avatarPath = map['avatarPath'];
              _updateAvatarToDB(imageFile);
            });
          }
        }
      });
    }
  }

  @protected
  _updateAvatarToDB(File image)async{
    try {
      String path = image.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

      FormData formData = new FormData.from({
        "file": new UploadFileInfo(image, name,
            contentType: ContentType.parse("image/$suffix"))
      });
      BaseOptions options = BaseOptions(method: "post");
      var dio = new Dio(options);
      var response = await dio.post(Address.uploadPhoto(),data: formData);
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _thumbnail = response.data["data"]["url"];
            CommonUtil.closePage(context);
            _addArticle("thumbnail",updateStatus);
          });
        }
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: Row(children: <Widget>[
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _thumbnail = "";
                              updateStatus = false;
                              _addArticle("",updateStatus);
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
                                                  hintText: '请输入搜索内容',
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
                                  _query = _searchController.text;
                                  _pageIndex = 1;
                                  _articleLst = [];
                                });
                              }
                              _getArticles();
                            },
                            child: Text('搜索'))
                      ])),
              _done == false
                  ? Center(child: Text("加载中......"))
                  : _articleLst.length == 0
                      ? Center(child: Text("暂无文章信息~"))
                      : Container(
                          width: double.infinity,
                          height: 500,
                          child: SmartRefresher(
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              enablePullDown: true,
                              enablePullUp: true,
                              header: WaterDropHeader(),
                              footer: CustomFooter(builder:
                                  (BuildContext context, LoadStatus mode) {
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
                                  itemCount: _articleLst.length,
                                  shrinkWrap: true)))
            ]))));
  }

  SlidableController _articleController = SlidableController();
  var res;
  Widget itemBuilder(BuildContext context, int index) {
    Map _article = _articleLst[index];
    return Padding(
        padding: EdgeInsets.only(left: 12),
        child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            controller: _articleController,
            key: Key(UniqueKey().toString()),
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (_article["_id"] != null && _article["_id"] != '') {
                CommonUtil.openPage(
                    context, DetailPage(articleId: _article["_id"]));
                } else {
                  CommonUtil.showMyToast("请刷新页面");
                }
              },
              child: Column(children: <Widget>[
                index == 0 ? SizedBox(height: 18) : SizedBox(),
                Container(
                    color: MyColors.white_fe,
                    padding: EdgeInsets.only(top: 18, bottom: 18),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 5),
                                    child: Text((index + 1).toString(),
                                        style: TextStyle(
                                            color: MyColors.grey_99,
                                            fontSize: MyFonts.f_18,
                                            fontWeight: FontWeight.bold))),
                                SizedBox(width: 8),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(_article["title"] ?? "",
                                          style: TextStyle(
                                              color: MyColors.black_1a,
                                              fontSize: MyFonts.f_16,
                                              fontWeight: FontWeight.normal)),
                                      SizedBox(height: 5),
                                      _article["subTitle"] != null
                                          ? Text(_article["subTitle"],
                                          style: TextStyle(
                                              color: MyColors.grey_99,
                                              fontSize: MyFonts.f_15))
                                          : Text(''),
                                      SizedBox(height: 5),
                                      Text(_article["UnitTen"].toString() + "热度",
                                          style: TextStyle(
                                              color: MyColors.grey_99,
                                              fontSize: MyFonts.f_15))
                                    ])
                              ])),
                      (_article["thumbnail"] != null &&
                          _article["thumbnail"] != '')
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                                  "http://${_article["thumbnail"]}",
                              width: 80,
                              height: 60))
                          : Container()
                    ])),
                SeparatorWidget()
              ])),
            actions: <Widget>[
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                      height: 100,
                      width: 30,
                      color: MyColors.orange_68,
                      child: Center(
                          child: Text(_article["recommend"] == true?"取消推荐":'设为推荐',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyColors.white_ff,
                                  fontSize: MyFonts.f_18)))),
                  onTap: () {
                    _updateArticle(_article["_id"],{"recommend":!_article["recommend"]},true,true);
                  })
            ],
            secondaryActions: <Widget>[
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                      height: 100,
                      width: 30,
                      color: MyColors.green_8d,
                      child: Center(
                          child: Text('修改',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyColors.white_ff,
                                  fontSize: MyFonts.f_18)))),
                  onTap: () {
                    _thumbnail = "";
                    updateStatus = true;
                    res = _article;
                    _addArticle(_article,updateStatus);
                  }),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                      height: 100,
                      width: 30,
                      color: _article["status"] == false?MyColors.green_ad:MyColors.red_43,
                      child: Center(
                          child: Text(_article["status"] == false?'启用':'禁用',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyColors.white_ff,
                                  fontSize: MyFonts.f_18)))),
                  onTap: () {
                    if(mounted){
                      setState(() {
                        _article["status"] = !_article["status"];
                      });
                    }
                    _updateArticle(_article["_id"],{"status":!_article["status"]},false,false);
                  })
            ]
        ));
  }
}
