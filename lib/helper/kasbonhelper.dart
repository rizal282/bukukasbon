// class ini dibuat untuk handling input data orang yg baru kasbon

class Kasbonhelper {

  // set variabel untuk menampung input dari user
  int id;
  String _nama;
  String _kontak;
  String _totalHarga;
  String _jatuhTempo;
  String _foto;
  String _status;

  // ini adalah konstruktor untuk men-set value variable diatas
  Kasbonhelper(this._nama, this._kontak, this._totalHarga, this._jatuhTempo, this._foto, this._status);

  // ini untuk memecah / men-generate data dari bentuk array ke dalam bentuk variabel terpisah
  Kasbonhelper.fromMap(dynamic obj) {
    this._nama = obj["nama"];
    this._kontak = obj["kontak"];
    this._jatuhTempo = obj["jatuhTempo"];
     this._foto = obj["foto"];
    this._status = obj["status"];
  }

  String get nama => _nama;
  String get kontak => _kontak;
  String get totalHarga => _totalHarga;
  String get jatuhTempo => _jatuhTempo;
  String get foto => _foto;
  String get status => _status;

  // ini untuk membuat data array dari bentuk bentuk variabel terpisah
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map["nama"] = _nama;
    map["kontak"] = _kontak;
    map["totalHarga"] = _totalHarga;
    map["jatuhTempo"] = _jatuhTempo;
    map["foto"] = _foto;
    map["status"] = _status;

    return map;
  } 

  void setIdKasbon(int id){
    this.id = id;
  }
}