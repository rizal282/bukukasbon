import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// file ini menampilkan proses pembayaran kasbon

class BayarKabon extends StatefulWidget {
  final String nama, totalKasbon, tglTempo;

  const BayarKabon({Key key, this.nama, this.totalKasbon, this.tglTempo}) : super(key: key);
  @override
  _BayarKabonState createState() => _BayarKabonState();
}

class _BayarKabonState extends State<BayarKabon> {
  var database = DBHelper();
  List dataBayar = List();

  // variable yg menangkap value yg diinput user ketika bayar kasbon
  final _totalKasbon = new TextEditingController();
  final _sisaKasbon = new TextEditingController();
  final _bayarKasbon = new TextEditingController();

  // method proses pembayaran kasbon
  void simpanbayarKasbon() async {
    var now = DateTime.now(); // membuat tanggal
    var dbClient = await database.db; // memanggil komunikasi ke database

    // parsing tipe data string ke integer (text ke angka)
    int totalkasbon = int.parse(_totalKasbon.text);
    int sisakasbon = int.parse(_sisaKasbon.text);
    int bayarkasbon = int.parse(_bayarKasbon.text);

    // menghitung total sisa kasbon ketika pembyaran pertama
    int totalsisakasbon = totalkasbon - bayarkasbon;

    // menghitung total sisa kasbon ketika pembyaran berikutnya
    int sisakasbonlagi = sisakasbon - bayarkasbon;

    // cek jika belum pernah bayar
    if(dataBayar.length == 0){

      // jika membayar lunas
      if(totalsisakasbon == 0){
        await dbClient.rawQuery("INSERT INTO bayarkasbon(nama,jumlahbayar,sisakasbon,tgltempo,tglbayar) values('${widget.nama}','${_bayarKasbon.text}','${totalsisakasbon.toString()}','${widget.tglTempo}','$now')");
        await dbClient.rawQuery("UPDATE kasbon SET status = 'Lunas' WHERE nama = '${widget.nama}'");
      }else{

        // jika membayar diangsur
        await dbClient.rawQuery("INSERT INTO bayarkasbon(nama,jumlahbayar,sisakasbon,tgltempo,tglbayar) values('${widget.nama}','${_bayarKasbon.text}','${totalsisakasbon.toString()}','${widget.tglTempo}','$now')");
      }
    }else{ // cek jika pernah bayar
      if(sisakasbonlagi == 0){ // jika byar lunas
        await dbClient.rawQuery("INSERT INTO bayarkasbon(nama,jumlahbayar,sisakasbon,tgltempo,tglbayar) values('${widget.nama}','${_bayarKasbon.text}','${sisakasbonlagi.toString()}','${widget.tglTempo}','$now')");
        await dbClient.rawQuery("UPDATE kasbon SET status = 'Lunas' WHERE nama = '${widget.nama}'");
      }else{

        // jika bayar diangsur
        await dbClient.rawQuery("INSERT INTO bayarkasbon(nama,jumlahbayar,sisakasbon,tgltempo,tglbayar) values('${widget.nama}','${_bayarKasbon.text}','${sisakasbonlagi.toString()}','${widget.tglTempo}','$now')");
      }
    }


    // tampilkan pesan jika pembayaran berhasil
    Fluttertoast.showToast(
      msg: "Kasbon Sudah dibayar",
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT
    );

    // kosongkan text input bayar kasbon
    _bayarKasbon.text = "";
  }

  // ambil sisa kasbon jika ada pembayaran sebelumnya
  void getSisaKasbon() async {
    var dbClient = await database.db;
    var result = await dbClient.rawQuery("SELECT sisakasbon FROM bayarkasbon WHERE nama = '${widget.nama}' ORDER BY id DESC LIMIT 1");

    setState(() {
      dataBayar = result;
      print(dataBayar);
    });

    if(result.length != 0){
      _sisaKasbon.text = result[0]["sisakasbon"].toString();
    }else{
      _sisaKasbon.text = widget.totalKasbon;
    }
  }

  void setValueForm(){
    _totalKasbon.text = widget.totalKasbon;
  }

  @override
  void initState() {
    getSisaKasbon();
    setValueForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bayar Kasbon"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _totalKasbon,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Total Kasbon"
                ),
                enabled: false,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _sisaKasbon,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Sisa Kasbon"
                ),
                enabled: false,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _bayarKasbon,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Bayar Kasbon"
                ),
              ),
              SizedBox(height: 10,),
              OutlineButton(
                child: Text("Bayar Kasbon"),
                onPressed: () => simpanbayarKasbon(),
              )
            ],
          ),
        ),
      ),
    );
  }
}