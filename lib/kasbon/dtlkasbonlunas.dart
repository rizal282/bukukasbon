import 'dart:io';

import 'package:buku_kasbon/helper/DBHelper.dart'; // package untuk handle input output data ke database
import 'package:buku_kasbon/kasbon/pdfviewerpage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class Detailkasbonlunas extends StatefulWidget {
  final String nama, totalKasbon, tglKasbon; // variable untuk parameter menampilkan data detail kasbon yg lunas

  // konstruktor untuk set data variable diatas
  const Detailkasbonlunas(
      {Key key, this.nama, this.totalKasbon, this.tglKasbon})
      : super(key: key);

  @override
  _DetailkasbonlunasState createState() => _DetailkasbonlunasState();
}

class _DetailkasbonlunasState extends State<Detailkasbonlunas> {
  var db = DBHelper(); // paggil class ini untuk handel input output data ke database

  // proses hapus data kasbon lunas
  void hapusKasbonLunas() async {
    var dbClient = DBHelper();
    await dbClient.hapusKasbon(widget.nama); // hapus data kasbon yg lunas dengan acuan nama yg kasbon
    await dbClient.hapusDeskBarang(widget.nama); // hapus data deskripsi barang dengan acuan nama yg kasbon
    await dbClient.hapusBayarKasbon(widget.nama); // hapus data pembayaran kasbon dengan acuan nama yg kasbon
  }

  // cetak pdf
  void _cetakPdf(context) async {
    List listPdf = await db.getDetailKasbonLunas(widget.nama);

    final pw.Document pdf = pw.Document(deflate: zlib.encode);

    pdf.addPage(
        pw.MultiPage(
            orientation: pw.PageOrientation.landscape,
            build: (context) => [
              pw.Text("Nama : ${widget.nama}"),
              pw.Text("Status Kasbon : Lunas"),
              pw.Text("Detail Kasbon :"),
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>["Nama", "Barang", "Jumlah Item", "Satuan", "Harga Satuan", "Total"],
                ...listPdf.map((e) => [
                  e["nama"],
                  e["namabarang"],
                  e["jumlahbarang"].toString(),
                  e["satuan"],
                  e["hargapcs"].toString(),
                  e["subtotal"].toString(),
                ])
              ])
            ]
        )
    );

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = "$dir/laporan_kasbon_${widget.nama}_${DateTime.now()}.pdf";
    final File file = File(path);

    file.writeAsBytesSync(pdf.save());
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Pdfviewerpage(path: path,))
    );
  }


  // tampilan data detail kasbon yg sudah lunas
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ini judul halaman
      appBar: AppBar(
        title: Text("Detail kasbon : ${widget.nama}"),
      ),

      // isi halaman
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Jatuh Tempo : ${widget.tglKasbon}"), // menampilkan tgl jatuh tempo
              Divider(color: Colors.blue,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.nama), // menampilkan nama yg kasbon
                  Text("Belum Lunas")
                ],
              ),
              SizedBox(height: 15,),
              Text("Detail Kasbon : "),
              SizedBox(height: 15,),

              // menampilkan data detail barang kasbon lunas
              Container(
                width: double.infinity,
                height: 250,
                child: FutureBuilder(
                  future: db.getDetailKasbonLunas(widget.nama),
                  builder: (context, snapshot){
                    if(snapshot.hasData)
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(snapshot.data[i]["namabarang"]), // menampilkan data nama barang kasbon
                                Text(snapshot.data[i]["jumlahbarang"].toString()), // menampilkan data jumlah barang kasbon
                                Text(snapshot.data[i]["subtotal"].toString()), // menampilkan data subtotal harga barang kasbon
                              ],
                            ),
                          );
                        },
                      );
                    return Center(child: CircularProgressIndicator(),);
                  },
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total Kasbon : "), // menampilkan data total semua barang yg kasbon
                  Text(widget.totalKasbon),
                ],
              ),
              Divider(color: Colors.blue,),

              Card(
                elevation: 0,
                color: Colors.greenAccent,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.white,
                    child: Center(
                      child: Text(
                        "Cetak PDF",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      _cetakPdf(context);
                    },
                  ),
                ),
              ),

              // tombol hapus data detail kasbon yg lunas
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
                        "Hapus",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      hapusKasbonLunas();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Sukses"),
                                content: Text("Data Kasbon lunas dihapus!"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              ));
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
