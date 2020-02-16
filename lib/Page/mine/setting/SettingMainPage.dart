import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Page/LoginPage.dart';
import 'package:billsmac_app/Widget/SubprojectWidget.dart';
import 'package:path_provider/path_provider.dart';

import 'AboutUsPage.dart';
import 'AccountSecurityPage.dart';
import 'SetGesturePasswordPage.dart';
import 'package:apifm/apifm.dart' as Apifm;

///Author:chiuhol
///2020-2-7

class SettingMainPage extends StatefulWidget {
  @override
  _SettingMainPageState createState() => _SettingMainPageState();
}

class _SettingMainPageState extends State<SettingMainPage> {
  String _cache = '';
  String _contactUs = '18312108986';

  ///加载缓存
  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    print('临时目录大小: ' + value.toString());
    setState(() {
      _cache = _renderSize(value); // _cacheSizeStr用来存储大小的值
    });
  }

  ///循环计算文件的大小（递归）
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  ///格式化缓存文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }

  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    CommonUtil.showMyToast('清除缓存成功');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "设置",
            color: MyColors.white_fe,
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28)),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(children: <Widget>[
                  SizedBox(height: 2),
                  SubprojectWidget(
                    title: '账号与绑定设置',
                    icon: 0xe62a,
                    iconColor: MyColors.grey_e4,
                    rout: AccountSecurityPage(),
                  ),
                  SeparatorWidget(),
                  SubprojectWidget(
                    title: '密码锁',
                    icon: 0xe612,
                    iconColor: MyColors.grey_e4,
                    rout: SetGesturePasswordPage(),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _clearCache();
                      },
                      child: Container(
                          color: MyColors.white_fe,
                          padding: EdgeInsets.only(
                              left: 18, right: 18, top: 18, bottom: 18),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Icon(IconData(0xe629, fontFamily: 'MyIcons'),
                                      size: 24, color: MyColors.grey_e4),
                                  SizedBox(width: 8),
                                  Text('清除缓存',
                                      style: TextStyle(
                                          color: MyColors.black_32,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ]),
                                Row(children: <Widget>[
                                  Text(_cache ?? "",
                                      style: TextStyle(
                                          color: MyColors.grey_e2,
                                          fontSize: 14)),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 24,
                                    color: MyColors.grey_e2,
                                  )
                                ])
                              ]))),
                  SeparatorWidget(),
                  SubprojectWidget(
                      title: '好评鼓励', icon: 0xe616, iconColor: MyColors.grey_e4),
                  SeparatorWidget(),
                  SubprojectWidget(
                      title: '帮助与反馈',
                      icon: 0xe614,
                      iconColor: MyColors.grey_e4),
                  SeparatorWidget(),
                  SubprojectWidget(
                    title: '关于我们',
                    icon: 0xe61f,
                    iconColor: MyColors.grey_e4,
                    rout: AboutUsPage(),
                  ),
                  SeparatorWidget(),
                  SubprojectWidget(
                    title: '联系我们',
                    icon: 0xe607,
                    iconColor: MyColors.grey_e4,
                    subTitle: _contactUs,
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async{
                        String _token = await LocalStorage.get("Token").then((value){
                          return value;
                        });
                        Apifm.loginout(_token);
                        CommonUtil.openPage(context, LoginPage());
                      },
                      child: Container(
                          color: MyColors.white_fe,
                          padding: EdgeInsets.only(top: 18, bottom: 18),
                          child: Center(
                              child: Text("退出登录",
                                  style: TextStyle(
                                      color: MyColors.red_34,
                                      fontSize: MyFonts.f_15)))))
                ]))));
  }
}
