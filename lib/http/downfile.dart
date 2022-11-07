import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:magictank/alleventbus.dart';

class DownloadFile {
  /// 用于记录正在下载的url，避免重复下载
  static Map<String, CancelToken> downloadingUrls = {};

  /// 断点下载大文件
  static Future<void> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    void Function()? done,
    void Function(DioError)? failed,
  }) async {
    int downloadStart = 0;
    bool fileExists = false;

    File f = File(savePath);
    if (await f.exists()) {
      downloadStart = f.lengthSync();
      fileExists = true;
    } else {
      await f.create(recursive: true);
      fileExists = true;
    }

    if (fileExists && downloadingUrls.containsKey(url)) {
      return;
    }

    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };
    CancelToken cancelToken = CancelToken();
    downloadingUrls[url] = cancelToken;

    try {
      //开始下载文件
      var response = await dio.get<ResponseBody>(
        url,
        options: Options(
          /// 以流的方式接收响应数据
          responseType: ResponseType.stream,
          followRedirects: false,
          headers: {
            /// 分段下载重点位置
            "range": "bytes=$downloadStart-",
          },
        ),
      );
      File file = File(savePath);
      RandomAccessFile raf = file.openSync(mode: FileMode.append);
      int received = downloadStart;
      //下载连接中包含文件的总大小
      int total = await _getContentLength(response);
      if (received == total) {
        onReceiveProgress?.call(received, total);
        return;
      }
      Stream<Uint8List> stream = response.data!.stream;
      StreamSubscription<Uint8List>? subscription;
      subscription = stream.listen(
        (data) {
          /// 写入文件必须同步
          raf.writeFromSync(data);
          received += data.length;
          onReceiveProgress?.call(received, total);
        },
        onDone: () async {
          downloadingUrls.remove(url);
          await raf.close();
          done?.call();
        },
        onError: (e) async {
          await raf.close();
          downloadingUrls.remove(url);

          failed?.call(e as DioError);
        },
        cancelOnError: true,
      );
      cancelToken.whenCancel.then((_) async {
        await subscription?.cancel();
        await raf.close();
        await file.delete();
      });
    } on DioError catch (error) {
      /// 请求已发出，服务器用状态代码响应它不在200的范围内
      if (CancelToken.isCancel(error)) {
      } else {
        failed?.call(error);
      }
      downloadingUrls.remove(url);
    }
  }

  /// 获取下载的文件大小
  static Future<int> _getContentLength(Response<ResponseBody> response) async {
    try {
      var headerContent =
          response.headers.value(HttpHeaders.contentRangeHeader);

      if (headerContent != null) {
        return int.parse(headerContent.split('/').last);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  /// 取消任务
  static void cancelDownload(String url) {
    downloadingUrls[url]?.cancel();
    downloadingUrls.remove(url);
  }
}

void download(url, path, type) async {
  await DownloadFile.download(
    url: url,
    savePath: path,
    onReceiveProgress: (received, total) {
      if (total != -1) {
        switch (type) {
          case 0: //APP

            eventBus.fire(DownAppEvent((received / total * 100).toInt()));
            break;
          case 1: //钥匙数据

            eventBus.fire(DownKeyDataEvent((received / total * 100).toInt()));
            break;
          case 2: //芯片数据
            eventBus.fire(DownChipDataEvent((received / total * 100).toInt()));
            break;
          case 3:
            eventBus.fire(DownSmartDataEvent((received / total * 100).toInt()));
            break;
        }
      }
    },
    done: () {
      debugPrint("下载1完成");
    },
    failed: (e) {
      debugPrint("下载1失败：" + e.toString());
    },
  );
}

void cancelDown(url) {
  DownloadFile.cancelDownload(url);
}

void downdatafiles1() async {}

void downappfiles1() async {}
