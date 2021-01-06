// class ini dibuat untuk handling input data user baru (membuat akun baru ketika app sudah diinstall)

class Usertokohelper {

  // set variabel untuk menampung input dari user
  int id;
  String _username;
  String _password;
  String _namaToko;
  String _alamatToko;

  // ini adalah konstruktor untuk men-set value variable diatas
  Usertokohelper(this._username, this._password, this._namaToko, this._alamatToko);

  // ini untuk memecah / men-generate data dari bentuk array ke dalam bentuk variabel terpisah
  Usertokohelper.map(dynamic obj){
    this._username = obj["username"];
    this._password = obj["password"];
    this._namaToko = obj["namaToko"];
    this._alamatToko = obj["alamatToko"];
  }

  String get username => _username;
  String get password => _password;
  String get namaToko => _namaToko;
  String get alamatToko => _alamatToko;

  // ini untuk membuat data array  dari bentuk bentuk variabel terpisah
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map["username"] = _username;
    map["password"] = _password;
    map["namaToko"] = _namaToko;
    map["alamatToko"] = _alamatToko;

    return map;
  }

  void setIdUser(int id){
    this.id = id;
  }


}