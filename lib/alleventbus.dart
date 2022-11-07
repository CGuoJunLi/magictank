import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class DownFileEvent {
  int progress;
  DownFileEvent(this.progress);
}

class DownAppEvent {
  int progress;
  DownAppEvent(this.progress);
}

class DownKeyDataEvent {
  int progress;
  DownKeyDataEvent(this.progress);
}

class DownChipDataEvent {
  int progress;
  DownChipDataEvent(this.progress);
}

class DownSmartDataEvent {
  int progress;
  DownSmartDataEvent(this.progress);
}

class PreViewEvent {
  int side;
  int tooth;
  List<int> toothdepth;
  int wide;
  int thickness;
  int length;
  int depth;
  PreViewEvent(
    this.side,
    this.wide,
    this.thickness,
    this.tooth,
    this.length,
    this.depth,
    this.toothdepth,
  );
}

class MessageEvent {
  //消息监听  用于数控机返回数据等
  // 当前的索引
  int themeIndex;
  // 重写构造方法
  MessageEvent(this.themeIndex);
}

class BluetoothStateEvent {
  //监听蓝牙状态
  // 当前的索引
  bool state;
  // 重写构造方法
  BluetoothStateEvent(this.state);
}

class ErroEvent {
  //错误监听 用于数据机报错相关信息
  // 当前的索引
  List<String> message;
  int no;
  // 重写构造方法
  ErroEvent(
    this.message,
    this.no,
  );
}

class TipEvent {
  //用于数控机提示下一步操作
  //当前的索引
  //int code;
  int no;
  int messagecode;
  String page;
  // 重写构造方法
  TipEvent(
    this.page,
    this.no,
    this.messagecode,
  );
}

class UpdatEvent {
  int state;

  UpdatEvent(this.state);
}

class PowerStateEvent {
  int state;
  int dcstate;
  PowerStateEvent(this.state, this.dcstate);
}

class LcdUpBinStateEvent {
  int state;

  LcdUpBinStateEvent(this.state);
}

class LcdUpKeyStateEvent {
  int state;

  LcdUpKeyStateEvent(this.state);
}

class ActivtEvent {
  int state;
  ActivtEvent(this.state);
}

class ChangeSideEvent {
  int message;
  int type;
  int no;
  ChangeSideEvent(this.type, this.no, this.message);
}

class CNCConnectEvent {
  //连接状态
  bool state;
  CNCConnectEvent(this.state);
}

///数控机状态
class CNCStateEvent {
  //连接状态
  bool state;
  CNCStateEvent(this.state);
}

///更换铣刀导针状态
class CNCChangeXDStateEvent {
  //连接状态
  bool state;
  CNCChangeXDStateEvent(this.state);
}

///获取版本到版本号通知
class CNCGetVerEvent {
  //连接状态
  bool state;
  CNCGetVerEvent(this.state);
}

class MCConnectEvent {
  //连接状态
  bool state;
  MCConnectEvent(this.state);
}

class MCGetVerEvent {
  //连接状态
  bool state;
  MCGetVerEvent(this.state);
}

class MSConnectEvent {
  //连接状态
  bool state;
  MSConnectEvent(this.state);
}

class UpPageEvent {
  //更新界面
  int state;
  UpPageEvent(this.state);
}

class SearchKeyEvent {
  //更新界面
  bool state; //查找成功
  SearchKeyEvent(this.state);
}

class YmodelEvent {
  int rdata;
  YmodelEvent(this.rdata);
}

class BTStateEvent {
  int state;
  BTStateEvent(this.state);
}

class ChipReadEvent {
  //消息监听  用于数控机返回数据等
  // 当前的索引
  bool state;
  // 重写构造方法
  ChipReadEvent(this.state);
}

class ChipWriteEvent {
  // 当前的索引

  List<int> data;
  // 重写构造方法
  ChipWriteEvent(this.data);
}

class ChipReadStepEvent {
  //消息监听  用于数控机返回数据等
  // 当前的步数
  int step;
  // 重写构造方法
  ChipReadStepEvent(this.step);
}

//服务器状态
class NetStateEvent {
  //消息监听  用于数控机返回数据等
  // 当前的索引
  bool state;
  // 重写构造方法
  NetStateEvent(this.state);
}

//服务器消息监听
class NetChipReadEvent {
  //消息监听  用于数控机返回数据等
  // 当前的索引
  bool state;
  // 重写构造方法
  NetChipReadEvent(this.state);
}
