class CRC8CCIIT {
  late List<int> mResult;
  late int crc;

  CRC8CCIIT(List<int> b) {
    crc = 0x0;

    mResult = List.filled(b.length + 1, 0);
    int j = 0;
    for (int i in b) {
      crc8(i);
      mResult[j++] = i;
    }
    ref();
    mResult[j++] = crc & 0xff;
  }
  void crc8(int data) {
    //CRC-8/CCITT        x8+x6+x4+x3+x2+x1
    int G = 0x5E; //x8+x6+x4+x3+x2+x1
    int i = 1;
    for (int j = 0; j < 8; j++) {
      if ((crc & 0x80) != 0) {
        crc <<= 1;
        crc ^= G;
      } else {
        crc <<= 1;
      }
      if ((data & 0xff & i) != 0) {
        crc ^= G;
      }
      i <<= 1;
    }
  }

  void ref() {
    int c = 0;
    for (int i = 0; i < 8; i++) {
      c <<= 1;
      c |= crc & 1;
      crc >>= 1;
    }
    crc = c;
  }

  getResult() {
    return mResult;
  }
}
