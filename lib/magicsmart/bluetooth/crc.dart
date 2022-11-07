int checkdata(List<int> data) {
  int temp = 0;
  for (var i = 0; i < data.length - 1; i++) {
    temp += data[i];
  }
  return temp & 0xff;
}
