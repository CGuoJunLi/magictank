/*
final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open('libnative_add.so')
    : DynamicLibrary.process();

final int Function(int data, int crcvalue) crcchar = nativeAddLib
    .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('crcchar')
    .asFunction();

final Pointer<Uint8> Function(int len) creatPoint = nativeAddLib
    .lookup<NativeFunction<Pointer<Uint8> Function(Int32)>>('creatPoint')
    .asFunction();

final int Function(Pointer<Uint8>, int) getcrc32 = nativeAddLib
    .lookup<NativeFunction<Uint32 Function(Pointer<Uint8>, Uint32)>>('getcrc32')
    .asFunction();

final int Function(int, Pointer<Uint8>) crc32char = nativeAddLib
    .lookup<NativeFunction<Uint32 Function(Uint32, Pointer<Uint8>)>>(
        'crc32char')
    .asFunction();

final int Function(Pointer<Uint8>, int) Frame_verify = nativeAddLib
    .lookup<NativeFunction<Uint32 Function(Pointer<Uint8>, Uint32)>>(
        'Frame_verify')
    .asFunction();

//获取int数组的crc
int getcrcint(List<int> data) {
  int crcvalue = 0xffffffff;
  for (var i = 0; i < data.length; i++) {
    crcvalue = crcchar(data[i], crcvalue);
  }
  return crcvalue;
}

int getcrc8char(List<int> data) {
  Pointer<Uint8> temp = creatPoint(126);
  int crc = 0;
  ////print(data.length);
  for (var i = 0; i < 126; i++) {
    temp[i] = data[i];
  }
  crc = Frame_verify(temp, 126);
  return crc;
}

int getcrc32char(List<int> data) {
  Pointer<Uint8> temp = creatPoint(data.length);
  for (var i = 0; i < data.length; i++) {
    temp[i] = data[i];
  }
  int crc = 0;
  crc = crc32char(data.length, temp);
  return crc;
}

int getcharcrc(List<int> data) {
  int crcvalue = 0xffffffff;
  ////print(data.length);
  switch (data.length % 4) {
    case 1:
      data.add(0);
      data.add(0);
      data.add(0);
      break;
    case 2:
      data.add(0);
      data.add(0);
      break;
    case 3:
      data.add(0);
      break;
  }
  ////print(data.length);
  List<int> temp = []; //hex
  for (var i = 0;
      i <
          (data.length % 4 == 0
                  ? data.length ~/ 4
                  : data.length ~/ 4 + 4 - (data.length) % 4) -
              1;
      i++) {
    temp.add(hexToInt(data.sublist(4 * i, 4 * i + 4)));
  }
  for (var i = 0; i < temp.length; i++) {
    crcvalue = crcchar(temp[i], crcvalue);
  }
  ////print(crcvalue);
  return crcvalue;
}

//获取char数组的CRC
int getcrcchar(List<int> data, {bool type = false}) {
  ////print(data.length);
  ////print(data.length % 4 == 0
      ? data.length ~/ 4
      : data.length ~/ 4 + 4 - (data.length) % 4);
  for (var i = data.length % 4; i < 4; i++) {
    // data.add(0xff);
  }
  if (true) {
    switch (data.length % 4) {
      case 1:
        data.add(0);
        data.add(0);
        data.add(0);
        break;
      case 2:
        data.add(0);
        data.add(0);
        break;
      case 3:
        data.add(0);
        break;
    }
  }
  int crc = 0;
  Pointer<Uint8> temp = creatPoint(data.length % 4 == 0
      ? data.length ~/ 4
      : data.length ~/ 4 + 4 - (data.length) % 4);
  ////print(data.length);

  //Pointer<Uint8> temp = creatPoint(data.length);
  for (var i = 0; i < data.length; i++) {
    temp[i] = data[i];
  }
  // ////print(temp);
  // crc = getcrc32(temp, 4);
  crc = getcrc32(
      temp,
      data.length % 4 == 0
          ? data.length ~/ 4
          : data.length ~/ 4 + 4 - (data.length) % 4);
  ////print(crc);
  return crc;
} //e612d97A  7ad912e6

int StringhexToInt(String temp) {
  int val = 0;

  int len = temp.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = temp.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("Invalid hexadecimal value");
    }
  }
  //////print(val);
  return val;
}

int hexToInt(List<int> data) {
  int val = 0;
  String temp = "";
  data = List.from(data.reversed);

  for (var i = 0; i < data.length; i++) {
    temp = temp + intToFormatStringHex(data[i]);
  }
  int len = temp.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = temp.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("Invalid hexadecimal value");
    }
  }
  //////print(val);
  return val;
}

//Int 转16进制数据方法
//type 位数 2(char)4(int)8(long)
List<int> intToFormatHex(int num, int type) {
  List<int> temp = [];
  switch (type) {
    case 2:
      if (num < 0) {
        num = num & 0xff;
      }
      break;
    case 4:
      if (num < 0) {
        num = num & 0xffff;
      }
      break;
    case 8:
      if (num < 0) {
        num = num & 0xffffffff;
      }
      break;
  }
  String hexString = num.toRadixString(16);
  // debugPrint("hexString=$hexString");
  String formatString = hexString.padLeft(type, "0");
  // debugPrint("formatHexString=$formatString");
  for (var i = 0; i < formatString.length - 1; i = i + 2) {
    // ////print(formatString.substring(i, i + 2));
    temp.add(StringhexToInt(formatString.substring(i, i + 2)));
  }
  // ////print(temp);
  temp = List.from(temp.reversed);
  // ////print(temp);
  return temp;
}

String intToFormatStringHex(int num) {
  List<int> temp = [];
  String hexString = num.toRadixString(16);
  // debugPrint("hexString=$hexString");
  String formatString = hexString.padLeft(2, "0");
//  debugPrint("formatHexString=$formatString");
  // temp = List.from(temp.reversed);
  // ////print(temp);
  return formatString;
}

int getlistnum(List<dynamic> data, dynamic data2) {
  int num = 0;
  data.forEach((element) {
    if (element == data2) {
      num++;
    }
  });
  return num;
}


*/
//
Map asciicode = {
  "33": "!",
  "34": "\"",
  "35": "#",
  "36": "\$",
  "37": "%",
  "38": "&",
  "39": "'",
  "40": "(",
  "41": ")",
  "42": "*",
  "43": "+",
  "44": ",",
  "45": "-",
  "46": ".",
  "47": "/",
  "48": "0",
  "49": "1",
  "50": "2",
  "51": "3",
  "52": "4",
  "53": "5",
  "54": "6",
  "55": "7",
  "56": "8",
  "57": "9",
  "58": ":",
  "59": ";",
  "60": "<",
  "61": "=",
  "62": ">",
  "63": "?",
  "64": "@",
  "65": "A",
  "66": "B",
  "67": "C",
  "68": "D",
  "69": "E",
  "70": "F",
  "71": "G",
  "72": "H",
  "73": "I",
  "74": "J",
  "75": "K",
  "76": "L",
  "77": "M",
  "78": "N",
  "79": "O",
  "80": "P",
  "81": "Q",
  "82": "R",
  "83": "S",
  "84": "T",
  "85": "U",
  "86": "V",
  "87": "W",
  "88": "X",
  "89": "Y",
  "90": "Z",
  "91": "[",
  "92": "\\",
  "93": "]",
  "94": "^",
  "95": "_",
  "96": "`",
  "97": "a",
  "98": "b",
  "99": "c",
  "100": "d",
  "101": "e",
  "102": "f",
  "103": "g",
  "104": "h",
  "105": "i",
  "106": "j",
  "107": "k",
  "108": "l",
  "109": "m",
  "110": "n",
  "111": "o",
  "112": "p",
  "113": "q",
  "114": "r",
  "115": "s",
  "116": "t",
  "117": "u",
  "118": "v",
  "119": "w",
  "120": "x",
  "121": "y",
  "122": "z",
  "123": "{",
  "124": "|",
  "125": "}",
  "126": "~",
};

const List auchCRCHi = [
  0x0000,
  0x1021,
  0x2042,
  0x3063,
  0x4084,
  0x50A5,
  0x60C6,
  0x70E7,
  0x8108,
  0x9129,
  0xA14A,
  0xB16B,
  0xC18C,
  0xD1AD,
  0xE1CE,
  0xF1EF,
  0x1231,
  0x0210,
  0x3273,
  0x2252,
  0x52B5,
  0x4294,
  0x72F7,
  0x62D6,
  0x9339,
  0x8318,
  0xB37B,
  0xA35A,
  0xD3BD,
  0xC39C,
  0xF3FF,
  0xE3DE,
  0x2462,
  0x3443,
  0x0420,
  0x1401,
  0x64E6,
  0x74C7,
  0x44A4,
  0x5485,
  0xA56A,
  0xB54B,
  0x8528,
  0x9509,
  0xE5EE,
  0xF5CF,
  0xC5AC,
  0xD58D,
  0x3653,
  0x2672,
  0x1611,
  0x0630,
  0x76D7,
  0x66F6,
  0x5695,
  0x46B4,
  0xB75B,
  0xA77A,
  0x9719,
  0x8738,
  0xF7DF,
  0xE7FE,
  0xD79D,
  0xC7BC,
  0x48C4,
  0x58E5,
  0x6886,
  0x78A7,
  0x0840,
  0x1861,
  0x2802,
  0x3823,
  0xC9CC,
  0xD9ED,
  0xE98E,
  0xF9AF,
  0x8948,
  0x9969,
  0xA90A,
  0xB92B,
  0x5AF5,
  0x4AD4,
  0x7AB7,
  0x6A96,
  0x1A71,
  0x0A50,
  0x3A33,
  0x2A12,
  0xDBFD,
  0xCBDC,
  0xFBBF,
  0xEB9E,
  0x9B79,
  0x8B58,
  0xBB3B,
  0xAB1A,
  0x6CA6,
  0x7C87,
  0x4CE4,
  0x5CC5,
  0x2C22,
  0x3C03,
  0x0C60,
  0x1C41,
  0xEDAE,
  0xFD8F,
  0xCDEC,
  0xDDCD,
  0xAD2A,
  0xBD0B,
  0x8D68,
  0x9D49,
  0x7E97,
  0x6EB6,
  0x5ED5,
  0x4EF4,
  0x3E13,
  0x2E32,
  0x1E51,
  0x0E70,
  0xFF9F,
  0xEFBE,
  0xDFDD,
  0xCFFC,
  0xBF1B,
  0xAF3A,
  0x9F59,
  0x8F78,
  0x9188,
  0x81A9,
  0xB1CA,
  0xA1EB,
  0xD10C,
  0xC12D,
  0xF14E,
  0xE16F,
  0x1080,
  0x00A1,
  0x30C2,
  0x20E3,
  0x5004,
  0x4025,
  0x7046,
  0x6067,
  0x83B9,
  0x9398,
  0xA3FB,
  0xB3DA,
  0xC33D,
  0xD31C,
  0xE37F,
  0xF35E,
  0x02B1,
  0x1290,
  0x22F3,
  0x32D2,
  0x4235,
  0x5214,
  0x6277,
  0x7256,
  0xB5EA,
  0xA5CB,
  0x95A8,
  0x8589,
  0xF56E,
  0xE54F,
  0xD52C,
  0xC50D,
  0x34E2,
  0x24C3,
  0x14A0,
  0x0481,
  0x7466,
  0x6447,
  0x5424,
  0x4405,
  0xA7DB,
  0xB7FA,
  0x8799,
  0x97B8,
  0xE75F,
  0xF77E,
  0xC71D,
  0xD73C,
  0x26D3,
  0x36F2,
  0x0691,
  0x16B0,
  0x6657,
  0x7676,
  0x4615,
  0x5634,
  0xD94C,
  0xC96D,
  0xF90E,
  0xE92F,
  0x99C8,
  0x89E9,
  0xB98A,
  0xA9AB,
  0x5844,
  0x4865,
  0x7806,
  0x6827,
  0x18C0,
  0x08E1,
  0x3882,
  0x28A3,
  0xCB7D,
  0xDB5C,
  0xEB3F,
  0xFB1E,
  0x8BF9,
  0x9BD8,
  0xABBB,
  0xBB9A,
  0x4A75,
  0x5A54,
  0x6A37,
  0x7A16,
  0x0AF1,
  0x1AD0,
  0x2AB3,
  0x3A92,
  0xFD2E,
  0xED0F,
  0xDD6C,
  0xCD4D,
  0xBDAA,
  0xAD8B,
  0x9DE8,
  0x8DC9,
  0x7C26,
  0x6C07,
  0x5C64,
  0x4C45,
  0x3CA2,
  0x2C83,
  0x1CE0,
  0x0CC1,
  0xEF1F,
  0xFF3E,
  0xCF5D,
  0xDF7C,
  0xAF9B,
  0xBFBA,
  0x8FD9,
  0x9FF8,
  0x6E17,
  0x7E36,
  0x4E55,
  0x5E74,
  0x2E93,
  0x3EB2,
  0x0ED1,
  0x1EF0
];

Map ascii = {
  "!": 33,
  "\"": 34,
  "#": 35,
  "\$": 36,
  "%": 37,
  "&": 38,
  "'": 39,
  "(": 40,
  ")": 41,
  "*": 42,
  "+": 43,
  ",": 44,
  "-": 45,
  ".": 46,
  "/": 47,
  "0": 48,
  "1": 49,
  "2": 50,
  "3": 51,
  "4": 52,
  "5": 53,
  "6": 54,
  "7": 55,
  "8": 56,
  "9": 57,
  ":": 58,
  ";": 59,
  "<": 60,
  "=": 61,
  ">": 62,
  "?": 63,
  "@": 64,
  "A": 65,
  "B": 66,
  "C": 67,
  "D": 68,
  "E": 69,
  "F": 70,
  "G": 71,
  "H": 72,
  "I": 73,
  "J": 74,
  "K": 75,
  "L": 76,
  "M": 77,
  "N": 78,
  "O": 79,
  "P": 80,
  "Q": 81,
  "R": 82,
  "S": 83,
  "T": 84,
  "U": 85,
  "V": 86,
  "W": 87,
  "X": 88,
  "Y": 89,
  "Z": 90,
  "[": 91,
  "\\": 92,
  "]": 93,
  "^": 94,
  "_": 95,
  "`": 96,
  "a": 97,
  "b": 98,
  "c": 99,
  "d": 100,
  "e": 101,
  "f": 102,
  "g": 103,
  "h": 104,
  "i": 105,
  "j": 106,
  "k": 107,
  "l": 108,
  "m": 109,
  "n": 110,
  "o": 111,
  "p": 112,
  "q": 113,
  "r": 114,
  "s": 115,
  "t": 116,
  "u": 117,
  "v": 118,
  "w": 119,
  "x": 120,
  "y": 121,
  "z": 122,
  "{": 123,
  "|": 124,
  "}": 125,
  "~": 126,
};

int ref(int crc) {
  int re = 0;
  int i = 1;
  while (i > 0) {
    re <<= 1;
    re &= 0xff;
    if (crc & i > 0) {
      re |= 1;
      re &= 0xff;
    }
    i <<= 1;
    i &= 0xff;
  }
  return re;
}

int getcrc8char(List<int> data) //对一帧数据进行校验
{
  int i = 0;
  int crc = 0;
  for (i = 0; i < 126 - 1; i++) {
    crc = crc8ccitt(data[i], crc);
  }

  crc = ref(crc);
  return crc;
}

int crc8ccitt(int data, int crc) {
  int G = 0x5E; //x8+x6+x4+x3+x2+x1
  int i = 1;
  while (i > 0) {
    if (crc & 0x80 > 0) {
      crc <<= 1;
      crc &= 0xff;

      crc ^= G;
      crc &= 0xff;
    } else {
      crc <<= 1;
      crc &= 0xff;
    }
    if (data & i > 0) {
      crc ^= G;
      crc &= 0xff;
    }
    i <<= 1;
    i &= 0xff;
  }
  return crc;
}

int getcrc32char(List<int> source) {
  int wCRCin = 0xFFFFFFFF;
  int wCPoly = 0x04C11DB7;
  List<int> temp2 = List.from(source);
  ////print(temp2.length);

  switch (4 - (temp2.length % 4)) {
    case 1:
      temp2.add(0);
      break;
    case 2:
      temp2.add(0);
      temp2.add(0);
      break;
    case 3:
      temp2.add(0);
      temp2.add(0);
      temp2.add(0);
      break;
  }

  ////print(temp2.length);
  List<int> temp = [];
  ////print(temp2);

  for (var i = 0; i < temp2.length ~/ 4; i++) {
    temp.addAll(temp2.sublist(0 + i * 4, 4 + i * 4).reversed);
  }
  ////print(temp.length);
  ////print(temp);
  for (int i = 0; i < temp.length; i++) {
    for (int j = 0; j < 8; j++) {
      bool bit = ((temp[i] >> (7 - j) & 1) == 1);
      bool c31 = ((wCRCin >> 31 & 1) == 1);
      wCRCin <<= 1;
      if (c31 ^ bit) {
        wCRCin ^= wCPoly;
      }
    }
  }
  wCRCin &= 0xFFFFFFFF;
  return wCRCin ^= 0x00000000;
}

int getcrc16(List<int> source) {
  int crc = 0x0000;
  int i = 0;
  for (i = 0; i < source.length; i++) {
    crc = ((crc << 8) ^ auchCRCHi[((crc >> 8) ^ (0xff & source[i]))]) & 0xFFFF;
  }
  return crc;
}

int stringHexToInt(String temp) {
  int val = 0;

  int len = temp.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = temp.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw const FormatException("Invalid hexadecimal value");
    }
  }
  //////print(val);
  return val;
}

/// mode 多少位转int 默认4位转int
List<int> hexListToIntList(List<int> data, {int model = 4}) {
  List<int> temp = [];
  for (var i = 0; i < data.length ~/ model; i++) {
    temp.add(hexToInt(data.sublist(i * model, (i + 1) * model)));
  }
  return temp;
}

int hexToInt(List<int> data) {
  int val = 0;
  String temp = "";
  data = List.from(data.reversed);

  for (var i = 0; i < data.length; i++) {
    temp = temp + intToFormatStringHex(data[i]);
  }
  int len = temp.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = temp.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw const FormatException("Invalid hexadecimal value");
    }
  }
  //////print(val);
  return val;
}

String intToAscii(List source) {
  String temp = "";
  for (var i = 0; i < source.length; i++) {
    temp = temp + asciicode["${source[i]}"];
  }
  return temp;
}

//Int 转16进制数据方法
//type 位数 2(char)4(int)8(long)
List<int> intToFormatHex(int num, int type) {
  List<int> temp = [];
  switch (type) {
    case 2:
      if (num < 0) {
        num = num & 0xff;
      }
      break;
    case 4:
      if (num < 0) {
        num = num & 0xffff;
      }
      break;
    case 8:
      if (num < 0) {
        num = num & 0xffffffff;
      }
      break;
  }
  String hexString = num.toRadixString(16);
  // debugPrint("hexString=$hexString");
  String formatString = hexString.padLeft(type, "0");
  // debugPrint("formatHexString=$formatString");
  for (var i = 0; i < formatString.length - 1; i = i + 2) {
    // ////print(formatString.substring(i, i + 2));
    temp.add(stringHexToInt(formatString.substring(i, i + 2)));
  }
  // ////print(temp);
  temp = List.from(temp.reversed);
  // ////print(temp);
  return temp;
}

String intToFormatStringHex(int num) {
  //List<int> temp = [];
  String hexString = num.toRadixString(16);
  // debugPrint("hexString=$hexString");
  String formatString = hexString.padLeft(2, "0");
//  debugPrint("formatHexString=$formatString");
  // temp = List.from(temp.reversed);
  // ////print(temp);
  return formatString;
}

int getlistnum(List<dynamic> data, dynamic data2) {
  int num = 0;
  for (var element in data) {
    if (element == data2) {
      num++;
    }
  }
  return num;
}

List<int> asciiStringToint(String data) {
  List<int> temp = [];
  List str = data.split("");
  for (var i = 0; i < str.length; i++) {
    try {
      temp.add(ascii["${str[i]}"]);
    } catch (e) {
      temp.add(42);
    }
  }
  return temp;
}

String listStringToString(List<String> lstr) {
  String temp = "";
  for (var i = 0; i < lstr.length; i++) {
    temp = temp + lstr[i];
  }
  return temp;
}

List<String> intListToHexStringList(List<int> data) {
  List<String> temp = [];
  for (var i = 0; i < data.length; i++) {
    temp.add(intToFormatStringHex(data[i]));
  }
  return temp;
}

String intlisttohexstring(List<int> data) {
  String temp = "";
  for (var i = 0; i < data.length; i++) {
    temp += intToFormatStringHex(data[i]);
  }
  return temp;
}

List<int> stringHexToIntList(String string) {
  List<int> temp = [];
  List<String> temp2 = string.split("");
  for (var i = 0; i < temp2.length ~/ 2; i++) {
    temp.add(
        stringHexToInt(listStringToString(temp2.sublist(i * 2, i * 2 + 2))));
  }

  return temp;
}

//将str1中index位置的数据改为str2
String changeStringIndex(String str1, int index, str2) {
  String temp = "";
  List<String> temp2 = [];
  temp2 = str1.split("");
  temp2[index] = str2;
  for (var i = 0; i < temp2.length; i++) {
    temp += temp2[i];
  }
  return temp;
}
