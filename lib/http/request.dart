import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../alleventbus.dart';

class Request {
  // 配置 Dio 实例
  static final BaseOptions _options = BaseOptions(
    baseUrl: 'https://www.xingruiauto.com/',
    //connectTimeout: 5000,
    // receiveTimeout: 10000,
  );

  // 创建 Dio 实例
  static final Dio _dio = Dio(_options);

  // _request 是核心函数,所有的请求都会走这里
  static Future<T> _request<T>(String path,
      {String? method, Map? params, data}) async {
    // restful 请求处理
    if (params != null) {
      params.forEach((key, value) {
        //  if (path.indexOf(key) != -1) {
        if (path.contains(key)) {
          path = path.replaceAll(":$key", value.toString());
        }
      });
    }
    // LogUtil.v(data, tag: '发送的数据为：');
    // print(data);
    //print(path);
    // Response response =
    //     await _dio.request(path, data: data, options: Options(method: method));
    // ////print(response.statusMessage);
    // ////print(response.redirects);
    // return (response.data);

    try {
      Response response = await _dio.request(path,
          data: data, options: Options(method: method));
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // ////print(response.data);
          // if (response.data['status'] != 200) {
          //   //   LogUtil.v(response.data['status'], tag: '服务器错误,状态码为：');
          //   EasyLoading.showInfo('服务器错误,状态码为：${response.data['status']}');
          //   return Future.error(response.data['msg']);
          // } else {
          //   //   LogUtil.v(response.data, tag: '响应的数据为：');
          //   ////print(response.data);
          //   if (response.data is Map) {
          //     return response.data;
          //   } else {
          //     return json.decode(response.data.toString());
          //   }
          // }
          if (response.data is Map) {
            return response.data;
          } else {
            return json.decode(response.data.toString());
          }
        } catch (e) {
          // LogUtil.v(e, tag: '解析响应数据异常');
          ////print(e);
          return Future.error('解析响应数据异常');
        }
      } else {
        //  LogUtil.v(response.statusCode, tag: 'HTTP错误,状态码为：');
        ////print(response.data);
        // EasyLoading.showInfo('HTTP错误,状态码为：${response.statusCode}');
        Fluttertoast.showToast(msg: 'HTTP错误,状态码为：${response.statusCode}');
        _handleHttpError(response.statusCode!);
        return Future.error('HTTP错误');
      }
    } on DioError catch (e, s) {
      //  LogUtil.v(_dioError(e), tag: '请求异常');
      debugPrint("请求异常$s");
      debugPrint("请求异常$e");
      Fluttertoast.showToast(msg: _dioError(e));
      //   EasyLoading.showInfo(_dioError(e));
      return Future.error(_dioError(e));
    } catch (e, s) {
      //LogUtil.v(e, tag: '未知异常');
      debugPrint("未知异常$s");
      return Future.error('未知异常');
    }
  }

  static Future<T> _download<T>(String path, String filepath) async {
    try {
      Response response = await _dio.download(path, filepath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          ////print(received / total * 100);
          eventBus.fire(DownFileEvent((received / total * 100).toInt()));
        } else {
          debugPrint("出错了");
        }
      });
      ////print(response.data);
      return response.data;
    } catch (e) {
      eventBus.fire(DownFileEvent(-1));
      return Future.error('网络错误!');
    }

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   try {
    //     if (response.data is Map) {
    //       return response.data;
    //     } else {
    //       return json.decode(response.data.toString());
    //     }
    //   } catch (e) {
    //     // LogUtil.v(e, tag: '解析响应数据异常');
    //     ////print(e);
    //     return Future.error('解析响应数据异常');
    //   }
    // } else {
    //   //  LogUtil.v(response.statusCode, tag: 'HTTP错误,状态码为：');
    //   EasyLoading.showInfo('HTTP错误,状态码为：${response.statusCode}');
    //   _handleHttpError(response.statusCode!);
    //   return Future.error('HTTP错误');
    // }
    // } on DioError catch (e, s) {
    //   //  LogUtil.v(_dioError(e), tag: '请求异常');
    //   debugPrint("请求异常");
    //   ////print(e);
    //   ////print(s);
    //   EasyLoading.showInfo(_dioError(e));
    //   return Future.error(_dioError(e));
    // } catch (e, s) {
    //   //   LogUtil.v(e, tag: '未知异常');
    //   return Future.error('未知异常');
    // }
  }

  // 处理 Dio 异常
  static String _dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return "网络连接超时,请检查网络设置";

      case DioErrorType.receiveTimeout:
        return "服务器异常,请稍后重试!";

      case DioErrorType.sendTimeout:
        return "网络连接超时,请检查网络设置";

      case DioErrorType.response:
        return "服务器异常,请稍后重试!";

      case DioErrorType.cancel:
        return "请求已被取消,请重新请求";

      case DioErrorType.other:
        return "网络异常,请稍后重试!";

      default:
        return "Dio异常";
    }
  }

  // 处理 Http 错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权,请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败,错误码：$errorCode';
    }
    Fluttertoast.showToast(msg: message);
    //  EasyLoading.showError(message);
  }

  static Future<T> get<T>(String path, {Map? params}) {
    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    //   return null;
    // };
    return _request(path, method: 'get', params: params);
  }

  static Future<T> post<T>(String path, {Map? params, data}) {
    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    //   return null;
    // };
    return _request(path, method: 'post', params: params, data: data);
  }

  static Future<T> downfile<T>(String path, String filepath) {
    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    //   return null;
    // };
    return _download(path, filepath);
  }

  downprogressCallback(Function downprogress) {}
  // 这里只写了 get 和 post,其他的别名大家自己手动加上去就行
}
