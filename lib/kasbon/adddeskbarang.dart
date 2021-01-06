import 'dart:ffi';

import 'package:buku_kasbon/helper/DBHelper.dart'; // package untuk komunikasi dgn database
import 'package:buku_kasbon/helper/deskbrghelper.dart'; // package untuk handling data deskripsi barang
import 'package:flutter/material.dart'; // package untuk membuat komponen tampilan ui

class Adddeskbarang extends StatefulWidget {
  final String
      nama; // variabel untuk memfilter deskripsi barang sesuai nama siapa yg kasbon

  // set variable nama menggunakan konstruktor
  const Adddeskbarang({Key key, this.nama})
      : super(key: key); // nama orang yang kasbon
  @override
  _AdddeskbarangState createState() => _AdddeskbarangState();
}

class _AdddeskbarangState extends State<Adddeskbarang> {
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // untuk validasi form input data

  // untuk menangkap value yg diinput user
  final _namabarang = new TextEditingController();
  final _jumlahbarang = new TextEditingController();
  final _satuanbarang = new TextEditingController();
  final _hargapcs = new TextEditingController();

  var subTotal;
  var _tgl = DateTime.now().toString().split(" ");

  // untuk menghapus value form input
  void resetForm() {
    _namabarang.text = "";
    _jumlahbarang.text = "";
    _hargapcs.text = "";
    _satuanbarang.text = "";
  }

  // method untuk proses simpan data deskripsi barang ke database
  void simpanDeskBrg() async {
    // replace jika user input koma
    final jumlahAsli = _jumlahbarang.text;
    final temukan = ",";
    final ganti = ".";

    var newJumlah = jumlahAsli.replaceAll(temukan, ganti);

    if (_hargapcs.text.contains(".") || _hargapcs.text.contains(",")) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Warning"),
                content: Text("Jangan masukan koma atau titik di kolom harga!"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"))
                ],
              ));
    } else {
      // konversi ke tipe data double
      var jmlbrg = double.parse(newJumlah);
      var hrgbrg = double.parse(_hargapcs.text);

      setState(() {
        subTotal = jmlbrg * hrgbrg;
      });

      print(subTotal);

      var db = DBHelper();
      var deskBarang = Deskbrghelper(widget.nama, _namabarang.text, jmlbrg,
          _satuanbarang.text, hrgbrg, subTotal, _tgl[0]);

      await db.addDeskBarang(deskBarang);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sukses"),
                content: Text("Detail Kasbon baru disimpan!"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        resetForm();
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail barang kasbon ${widget.nama}"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              // form input nama barang
              TextFormField(
                controller: _namabarang,
                decoration: InputDecoration(
                    labelText: "Nama Barang",
                    hintText: "Masukan nama barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),

              // form input jumlah barang
              TextFormField(
                controller: _jumlahbarang,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Jumlah Barang",
                    hintText: "Masukan jumlah barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),

              // form input satuan barang
              TextFormField(
                controller: _satuanbarang,
                decoration: InputDecoration(
                    labelText: "Satuan Barang",
                    hintText: "Masukan satuan barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),

              // form input harga barang
              TextFormField(
                controller: _hargapcs,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Harga Barang",
                    hintText: "Masukan harga barang",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),

              // tombol untuk action simpan data
              Card(
                elevation: 0,
                color: Colors.blueAccent,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.white,
                    child: Center(
                      child: Text(
                        "Simpan",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onTap: () {
                      simpanDeskBrg();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
