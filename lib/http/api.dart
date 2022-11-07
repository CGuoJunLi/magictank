import 'package:dio/dio.dart';

import 'package:magictank/http/downfile.dart';
import 'package:magictank/http/request.dart';

class Api {
  static adduid(data) {
    return Request.get("tank/adduid/?stm=$data");
  }

  static isactivation(data) {
    return Request.get("tank/isactivation/?sn=$data");
  }

  //登陆 或者创建
  static login(Map<String, dynamic> data) {
    return Request.post(
      "tank/userlogin/",
      data: FormData.fromMap(data),
    );
  }

  static create(Map<String, dynamic> data) {
    return Request.post(
      "tank/usercreate/",
      data: FormData.fromMap(data),
    );
  }

  //更新用户信息
  static updatauserinfo(Map<String, dynamic> data) {
    return Request.post(
      "tank/updatauserinfo/",
      data: FormData.fromMap(data),
    );
  }

  //获取用户信息
  static getuserinfo(Map<String, dynamic> data) {
    return Request.post(
      "tank/getuserinfo/",
      data: FormData.fromMap(data),
    );
  }

  static downfile(String url, String path, type) {
    //return Request.downfile(url, path);
    switch (type) {
      case 4:
        return Request.downfile(url, path);
      default:
        download(url, path, type);
        break;
    }
  }

  static appIsUp(appver) {
    //检测APP是否需要升级
    return Request.get(
      "tank/isupapp/?version=" + appver,
    );
  }

  ///version=${appData.keydataver}&limit=${appData.limit}
  static keydataIsUp(keyver) {
    //检测APP是否需要升级
    return Request.get(
      "tank/isKeyUp/?" + keyver,
    );
  }

  static appVer(language) {
    //获取当前语言的APP版本
    return Request.get(
      "tank/appver/?language=" + language,
    );
  }

  static tankVer(language, pcb, jg) {
    //获取当前语言的tank固件版本
    return Request.get(
      "tank/Binver/?language=$language&PCB=$pcb&JQ=$jg",
    );
  }

  static keyVer(language) {
    //获取当前语言的钥匙数据版本
    return Request.get(
      "tank/keyver/?language=" + language,
    );
  }

  static tankvarList(language, pcb, jg, sn) {
    //获取当前语言的钥匙数据版本
    return Request.get(
      "tank/varList/?language=$language&PCB=$pcb&JQ=$jg&sn=$sn",
    );
  }

  static lcdvarList(language, pcb, jg) {
    //获取当前语言的钥匙数据版本
    return Request.get(
      "tank/verlcdlist/?language=$language&PCB=$pcb&JQ=$jg",
    );
  }

  static tankIsUp(language, version, pcb, jg, sn) {
    return Request.get(
      "tank/isTankBinUp/?language=$language&version=$version&pcb=$pcb&jg=$jg&sn=$sn",
    );
  }

  static lcdIsUp(language, version, pcb, jg) {
    return Request.get(
      "tank/isLCDBinUp/?language=$language&version=$version&pcb=$pcb&jg=$jg",
    );
  }

  static encryptBin(data) {
    //获取当前语言的钥匙数据版本
    return Request.get(
      "tank/encryptBin/?$data",
    );
  }

  static encryptLcdBin(data) {
    //获取当前语言的钥匙数据版本
    return Request.get(
      "tank/encryptlcdBin/?$data",
    );
  }

  static upUserStars(Map<String, dynamic> data) {
    return Request.post("tank/upuserstars/", data: FormData.fromMap(data));
  }

  static getUserStars(data) {
    return Request.get("tank/getuserstars/?$data");
  }

  static delUserStars(Map<String, dynamic> data) {
    return Request.post("tank/deluserstars/", data: FormData.fromMap(data));
  }

  static getUserHistory(data) {
    return Request.get("tank/getuserhistory/?$data");
  }

  static upUserHistory(Map<String, dynamic> data) {
    return Request.post("tank/upuserhistory/", data: FormData.fromMap(data));
  }

  static delUserHistory(Map<String, dynamic> data) {
    return Request.post("tank/deluserhistory/", data: FormData.fromMap(data));
  }

  static getUserKey(data) {
    return Request.get("tank/getuserkey/?$data");
  }

  static upUserKey(Map<String, dynamic> data) {
    return Request.post("tank/upuserkey/", data: FormData.fromMap(data));
  }

  static delUserKey(Map<String, dynamic> data) {
    return Request.post("tank/deluserkey/", data: FormData.fromMap(data));
  }

  static getUserModel(data) {
    return Request.get("tank/getusermodel/?$data");
  }

  static upUserModel(Map<String, dynamic> data) {
    return Request.post("tank/upusermodel/", data: FormData.fromMap(data));
  }

  static delUserModel(Map<String, dynamic> data) {
    return Request.post("tank/delusermodel/", data: FormData.fromMap(data));
  }

  static getSharedKey(data) {
    return Request.get("tank/getsharedkey/?$data");
  }

  static upSharedKey(Map<String, dynamic> data) {
    return Request.post("tank/upsharedkey/", data: FormData.fromMap(data));
  }

  static delSharedKey(Map<String, dynamic> data) {
    return Request.post("tank/delsharedkey/", data: FormData.fromMap(data));
  }

  static getSharedModel(data) {
    return Request.get("tank/getsharedmodel/?$data");
  }

  static upSharedModel(Map<String, dynamic> data) {
    return Request.post("tank/upsharedmodel/", data: FormData.fromMap(data));
  }

  static delSharedModel(Map<String, dynamic> data) {
    return Request.post("tank/delsharedmodel/", data: FormData.fromMap(data));
  }

//用户客户资料
  static getUserClient(data) {
    return Request.get("tank/getuserclient/?$data");
  }

  static getToken(data) {
    return Request.get("tank/gettoken/?token=$data");
  }

  static getAdpage() {
    return Request.get("tank/getad/?id=1");
  }

  static upToken(Map<String, dynamic> data) {
    return Request.post("tank/uptoken/", data: FormData.fromMap(data));
  }

//用户客户资料
  static upUserClient(Map<String, dynamic> data) {
    return Request.post("tank/upuserclient/", data: FormData.fromMap(data));
  }

//用户客户资料
  static delUserClient(Map<String, dynamic> data) {
    return Request.post("tank/deluserclient/", data: FormData.fromMap(data));
  }

  static searchBittng(data) {
    return Request.get("instacode/searchbitting/?$data");
  }

  static getCarList(data) {
    return Request.get("instacode/allcar/?$data");
  }

  static getBitting(data) {
    return Request.get("instacode/getbitting/?$data");
  }

  static chipVer(language) {
    //获取当前语言的APP版本
    return Request.get(
      "tank/chipver/?language=" + language,
    );
  }

  static mcvarList(language) {
    //获取当前语言的钥匙数据版本
    return Request.get(
      "tank/verMcList/?language=$language",
    );
  }

  static smartVer(language) {
    //获取当前语言的APP版本
    return Request.get(
      "tank/smartver/?language=" + language,
    );
  }

  static mcBinVer(language) {
    //magiclone 服务器最新版本
    return Request.get(
      "tank/McBinver/?language=" + language,
    );
  }

  static smartBinVer(language) {
    //magiclone 服务器最新版本
    return Request.get(
      "tank/McBinver/?language=" + language,
    );
  }

  static mcIsUp(mcbinver) {
    //检测magicclone是否需要升级
    return Request.get(
      "tank/isMcBinUp/?version=" + mcbinver,
    );
  }

  static chipIsUp(chipdataver) {
    //检测芯片是否需要升级
    return Request.get(
      "tank/isChipUp/?version=" + chipdataver,
    );
  }

  static smartIsUp(smartdataver) {
    //检测芯片是否需要升级
    return Request.get(
      "tank/isSmartUp/?version=" + smartdataver,
    );
  }

  static sendcode(Map<String, dynamic> data) {
    return Request.post(
      "tank/getmessagecode/",
      data: FormData.fromMap(data),
    );
  }
}
