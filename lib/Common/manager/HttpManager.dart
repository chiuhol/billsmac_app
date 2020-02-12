import 'dart:collection';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import '../local/LocalStorage.dart';
import '../BaseCommon.dart';
import '../util/CommonUtil.dart';
import '../event/HttpErrorEvent.dart';
import 'package:billsmac_app/Page/LoginPage.dart';

class ResultData {
  var data;
  bool result;

  ResultData(this.data, this.result);
}

class HttpManager {
  static final Dio _dio = Dio();

  static CancelToken _cancelToken = CancelToken();

  static const String attachment = "http://27.128.171.84:8090/attachment";
  static const String upload = "http://27.128.171.84:8090/api/attachment/upload";

  static const CONTENT_TYPE_FORM = "application/json";
  static const CONTENT_TYPE_FILE = 'application/x-jpg';

//  static Map optionParams = {
//    "timeoutMs": 10000,
//    "authorizationCode": null,
//  };

  static netFetch(
      context, url, params, Map<String, String> header, Options option,
      {noTip = false, token = ''}) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResultData(
          HttpErrorEvent.errorHandleFunction("无网络链接请检查网络", noTip), false);
    }

    Response response;
    try {
      response = await _dio.post(url, data: params, cancelToken: _cancelToken);
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        e.message = "与服务器连接超时";
      } else {
        e.message = "与服务器连接发生错误";
      }

      if (CommonUtil.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
        if (params != null) {
          print('请求异常参数: ' + params.toString());
        }
      }
      return new ResultData(
          HttpErrorEvent.errorHandleFunction(e.message, noTip), false);
    }

    if (CommonUtil.DEBUG) {
      print('请求url: ' + url);
      print('请求头: ' + _dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }

    if (response.statusCode == 200) {
      var responseData = response.data;
      if (responseData["code"] == 200) {
        if (responseData['data'] != null) {
          return new ResultData(responseData['data'], true);
        } else if (responseData['message'] != null) {
          return new ResultData(responseData['message'], false);
        } else {
          return new ResultData('', true);
        }
      } else {
        String failReason = response.data["message"];
        if (url != "/api/store/findWithUserId") {
//            showToast(failReason);
        }
        if (failReason == "会话已过期，请重新登录" || failReason == "会话已失效，请重新登录") {
          LocalStorage.setLogoutState();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        } else {
          return new ResultData(responseData['message'], false);
        }
        print("这个$url接口出现了问题！");
      }
    } else {
//        showComplexToast(ToastType.failure);
    }
  }

//  static fileNetFetch(context, url, path) async {
//    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
//    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
//
//    FormData formData = new FormData.from({
//      "filtType": "image",
//      "file": new UploadFileInfo(new File(path), name,
//          contentType: ContentType.parse("image/$suffix"))
//    });
//
//    Dio dio = new Dio();
//    Response response;
//    try {
//      response = await dio.post(url, data: formData);
//    } on DioError catch (e) {
//      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
//        e.message = "与服务器连接超时";
//      } else {
//        e.message = "与服务器连接发生错误";
//      }
//
//      if (CommonUtil.DEBUG) {
//        print('请求异常: ' + e.toString());
//        print('请求异常url: ' + url);
//      }
//    }
//
//    if (CommonUtil.DEBUG) {
//      print('请求url: ' + url);
//
//      if (response != null) {
//        print('返回参数: ' + response.toString());
//      }
//      if (optionParams["authorizationCode"] != null) {
//        print('authorizationCode: ' + optionParams["authorizationCode"]);
//      }
//    }
//    var responseData = response.data;
//    if (responseData['code'] == 401) {
//      await clearAuthorization();
//      Navigator.pushReplacementNamed(context, null); //to do: LoginPage.sName
//    } else if (responseData['code'] == 200) {
//      return new ResultData(responseData['data'], true);
//    }
//  }

  ///清除授权
//  static clearAuthorization() async {
//    optionParams["authorizationCode"] = null;
//    await LocalStorage.remove(BaseCommon.TOKEN);
//  }

  static void cancelRequest() {
    _cancelToken.cancel();
    CommonUtil.showMyToast('请求已取消');
    _cancelToken = CancelToken();
  }

  static void onLogin(String token) {
    _dio.options.headers = {"Access-Token": token};
  }

  static void onLogout() {
    _dio.options.headers = {"Access-Token": ""};
  }
}
