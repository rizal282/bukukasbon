import 'dart:convert';
import 'dart:typed_data';

import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:buku_kasbon/kasbon/bayarkasbon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DtlKasbonBlmLunas extends StatefulWidget {
  final String nama, totalKasbon, tglKasbon, foto; // variable sebagai parameter untuk menampilkan data kasbon yg belum lunas

  // konstruktor untuk set data variable diatas
  const DtlKasbonBlmLunas({Key key, this.nama, this.totalKasbon, this.tglKasbon, this.foto}) : super(key: key);
  @override
  _DtlKasbonBlmLunasState createState() => _DtlKasbonBlmLunasState();
}

class _DtlKasbonBlmLunasState extends State<DtlKasbonBlmLunas> {
  List tgl;
  var db = DBHelper();
  Uint8List _imageBytes;

  // initState adalah method yg berjalan otomatis ketika page ditampilkan
  @override
  void initState() {
    tgl = widget.tglKasbon.split(" ");
    db.getDetailKasbonBlmLunas(widget.nama); // function atau method ini berasal dari file dbhelper, untuk menampilkan detail kasbon yg blm lunas

    setState(() {
      _imageBytes = Base64Decoder().convert(widget.foto);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Kasbon Anda"),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Jatuh Tempo : ${tgl[0]}"), // menampilkan tgl jatuh tempo
              SizedBox(height: 10,),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.memory(_imageBytes),
                ),
              ),
              Divider(color: Colors.blue,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.nama),
                  Text("Belum Lunas") // menampilkan keterangan belum lunas
                ],
              ),
              SizedBox(height: 15,),
              Text("Detail Kasbon : "), // menampilkan data detail kasbon
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 250,
                child: FutureBuilder( // future builder adalah class dari material.dart yg fungsinya men-generate data array
                  future: db.getDetailKasbonBlmLunas(widget.nama),
                  builder: (context, snapshot){
                    if(snapshot.hasData)

                    // kode dibawah ini menampilan item detail barang kasbon yg blm lunas
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(snapshot.data[i]["namabarang"]), // menampilkan data namabarang
                                Text("${snapshot.data[i]["jumlahbarang"].toString()} ${snapshot.data[i]["satuan"]}"), // menampilkan data jumlah barang, dan satuan
                                Text(snapshot.data[i]["subtotal"].toString()), // menampilkan data subtotal harga kasbon
                              ],
                            ),
                          );
                        },
                      );
                    return Center(child: CircularProgressIndicator(),); // ini adalah icon loading, akan tampil ketika data belum siap ditampilkan
                  },
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total Kasbon : "),
                  Text(widget.totalKasbon), // menampilkan total seluruh kasbon
                ],
              ),
              Divider(color: Colors.blue,),

              // button untuk aksi bayar kasbon
              Center(
                child: OutlineButton(
                  child: Text("Bayar"),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BayarKabon(nama: widget.nama,totalKasbon: widget.totalKasbon, tglTempo: widget.tglKasbon,))
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
