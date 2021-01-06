// class ini dibuat untuk handling input data deskripsi barang yg diambil kasbon

class Deskbrghelper {
  // set variabel untuk menampung input dari user
  int id;
  var _nama, _namabarang, _jumlahbarang, _satuan, _hargapcs, _subtotal, _tglinput;

  // ini adalah konstruktor untuk men-set value variable diatas
  Deskbrghelper(this._nama, this._namabarang, this._jumlahbarang, this._satuan, this._hargapcs, this._subtotal, this._tglinput);

  // ini untuk memecah / men-generate data dari bentuk array ke dalam bentuk variabel terpisah
  Deskbrghelper.fromMap(dynamic obj){
    this._nama = obj["nama"];
    this._namabarang = obj["namabarang"];
    this._jumlahbarang = obj["jumlahbarang"];
    this._satuan = obj["satuan"];
    this._hargapcs = obj["hargapcs"];
    this._subtotal = obj["subtotal"];
    this._tglinput = obj["tglinput"];
  }

  String get nama => _nama;
  String get namabarang => _namabarang;
  String get jumlahbarang => _jumlahbarang;
  String get satuan => _satuan;
  String get hargapcs => _hargapcs;
  String get subtotal => _subtotal.toString();
  String get tglinput => _tglinput;

  // ini untuk membuat data array  dari bentuk bentuk variabel terpisah
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["nama"] = _nama;
    map["namabarang"] = _namabarang;
    map["jumlahbarang"] = _jumlahbarang;
    map["satuan"] = _satuan;
    map["hargapcs"] = _hargapcs;
    map["subtotal"] = _subtotal;
    map["tglinput"] = _tglinput;

    return map;
  }

  // untuk set id data barang
  void setId(int id){
    this.id = id;
  }

}