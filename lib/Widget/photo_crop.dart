import 'dart:io';

import 'package:billsmac_app/Common/manager/HttpManager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_crop/image_crop.dart';
import 'package:billsmac_app/Common/CommonInsert.dart';

///@author chiuhol
///Photo crop
class PhotoCrop extends StatefulWidget {
  File _imageFile;

  PhotoCrop(this._imageFile);

  @override
  _PhotoCropState createState() => _PhotoCropState();
}

class _PhotoCropState extends State<PhotoCrop> {
  final cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    //隐藏状态栏
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    print("打开图片裁剪页");
  }

  @override
  void dispose() {
    super.dispose();
    //显示状态栏
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    print("关闭图片裁剪页");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(
            Icons.chevron_left,
            color: Colors.deepOrange,
            size: 45,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12, right: 15),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () async {
                //上传裁剪后的图片
                final crop = cropKey.currentState;
                final scale = crop.scale;
                final area = crop.area;
                final croppedFile = await ImageCrop.cropImage(
                  file: widget._imageFile,
                  area: crop.area,
                );
                _upLoadImage(croppedFile);

                ///图片成功上传后弹出
//                print('Image.file(croppedFile)');
//                print(Image.file(croppedFile));
//
////                _upLoadImage(croppedFile);
//
//                Map<String, dynamic> map = new Map<String, dynamic>();
//                map['avatarPath'] = 'test';
//                map['croppedFile'] = Image.file(croppedFile);
//
//                Navigator.pop(context, map);
              },
              child: Text(
                "确定",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
            width: 65,
          )
        ],
        elevation: 0,
      ),
      body: Container(
        child: Crop(
          key: cropKey,
          image: Image.file(widget._imageFile).image,
          aspectRatio: 1.0,
        ),
        color: Colors.black,
      ),
    );
  }

  _upLoadImage(File croppedFile) async {
    String _path = croppedFile.path;

    var _name = _path.substring(_path.lastIndexOf("/") + 1, _path.length);
    String _suffix = _name.split(".").last.toLowerCase();

    ContentType _contentType;

    if (_suffix == "jpg") {
      _contentType = ContentType("image", "jpeg");
    } else if (_suffix == "png") {
      _contentType = ContentType("image", 'png');
    }

    FormData _formData = new FormData.from({
      "file": new UploadFileInfo(croppedFile, _name, contentType: _contentType)
    });

    String url = HttpManager.upload;

    Dio dio = new Dio();
    try {
      Response response = await dio.post("$url", data: _formData);

      if (response != null) {
        if (response.statusCode == 200) {
          var resCode = response.data['code'];
          if (resCode == 200) {
            Map<String, dynamic> map = new Map<String, dynamic>();

            map['avatarPath'] = response.data['data'];
            map['croppedFile'] = Image.file(croppedFile);

            Navigator.pop(context, map);
          } else if (resCode == 400) {
            CommonUtil.showMyToast(response.data['message']);
          }
        }
      }
    } catch (e) {
      if (e.message.toString() == 'Http status error [413]') {
        CommonUtil.showMyToast('文件过大，请裁减');
      }
    }
  }
}
