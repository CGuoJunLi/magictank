import 'package:magictank/convers/convers.dart';

class DataProcessor {
  int mType = 0; //0:发送正常帧 1：ack 2：补发帧 3：结束帧
  List<int> mData = [];
  List<List<int>> frameList = [];
  int frameLen = 126; //数据长度

  List<int> frame(int mNo, List<int> mData) {
    List<int> f = List.filled(frameLen, 0);
    List<int> data = mData;
    f[0] = (mNo | mType << 6); //
    List.copyRange(f, 1, data);
    f[frameLen - 1] = getcrc8char(f);
    // CRC8CCIIT crc8CCIIT = new CRC8CCIIT(f);
    // return crc8CCIIT.getResult();
    //   debugPrint("计算之后$f");
    return f;
  }

  List<List<int>> writes(List<int> b) {
    frameList.clear();
    mData = b;
    final int len = mData.length;
    int sum = len ~/ (frameLen - 2);
    if (sum * (frameLen - 2) < mData.length) {
      sum += 1;
    }
    for (int i = 0; i < sum; i++) {
      List<int> bytes;
      if (i == sum - 1 || i % 64 == 63) {
        if (i == sum - 1) {
          bytes = List.filled(len - i * (frameLen - 2), 0);
        } else {
          bytes = List.filled(frameLen - 2, 0);
        }
        mType = 3;
        bytes = mData.sublist(
            (i * (frameLen - 2)), (i * (frameLen - 2)) + bytes.length);
        //System.arraycopy(mData, (i * (frameLen - 2)), bytes, 0, bytes.length);
      } else {
        if (i % 64 == 0) mType = 0;
        bytes = List.filled(frameLen - 2, 0);
        bytes = mData.sublist(
            (i * (frameLen - 2)), (i * (frameLen - 2)) + frameLen - 2);
        //  System.arraycopy(mData, i * (frameLen - 2), bytes, 0, frameLen - 2);
      }
      //    debugPrint("计算之前${i % 64} $bytes");
      frameList.add(frame(i % 64, bytes));
    }
    return frameList;
  }
}
