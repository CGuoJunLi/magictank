CNCBlutoothServer cncbtmodel = CNCBlutoothServer();

class CNCBlutoothServer {
  bool state = false;
  bool blSwitch = false;
  String btaddr = "";
}

bool getCncBtState() {
  return cncbtmodel.state;
}
