class DuedateHelper {
  int id;
  String _nama;
  String _tglTempo;
  String _tglBayar;

  DuedateHelper(this._nama, this._tglTempo, this._tglBayar);

  DuedateHelper.fromMap(dynamic obj){
    this._nama = obj["nama"];
    this._tglTempo = obj["tgltempo"];
    this._tglBayar = obj["tglbayar"];
  }

  String get nama => _nama;
  String get tglTempo => _tglTempo;
  String get tglBayar => _tglBayar;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["nama"] = this._nama;
    map["tgltempo"] = this._tglTempo;
    map["tglbayar"] = this._tglBayar;

    return map;
  }

  void setId(int id){
    this.id = id;
  }
}