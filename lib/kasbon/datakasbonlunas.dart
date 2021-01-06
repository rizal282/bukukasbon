import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:buku_kasbon/helper/kasbonhelper.dart';
import 'package:buku_kasbon/kasbon/dtlkasbonlunas.dart';
import 'package:flutter/material.dart';

// file ini menampilkan data kasbon yg sudah lunas

// class utama
class Datakasbonlunas extends StatefulWidget {
  @override
  _DatakasbonlunasState createState() => _DatakasbonlunasState();
}

// class untuk menampilkan data kasbon lunas
class _DatakasbonlunasState extends State<Datakasbonlunas> {
  var db = DBHelper(); // memanggil helper database

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.getKasbonLunas(), // memanggil method yg berfungsi mengambil data kasbon lunas
      builder: (context, snapshot){
        if(snapshot.hasError) print(snapshot.error); // cek jika terjadi error dalam proses ambil data

        var data = snapshot.data;

        return snapshot.hasData // jika data kasbon ada
        ? ListKasbonLunas(data) // tampilkan dalam class ini
        : Center(child: Text("Tidak ada data"),); // jika proses loading masih berjalan
      },
    );
  }
}

// class untuk menampilkan data item kasbon lunas
class ListKasbonLunas extends StatelessWidget {
  final List<Kasbonhelper> list; // variabel penampung data kasbon

  ListKasbonLunas(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder( // membuat list untuk menampilkan data kasbon
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i){
        var jt = list[i].jatuhTempo.split(" ");
        return GestureDetector(
          onTap: (){ // list ketika di tap akan mengarah ke detail kasbon
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Detailkasbonlunas(nama: list[i].nama, tglKasbon: list[i].jatuhTempo, totalKasbon: list[i].totalHarga,))
            );
          },
          child: Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Row( // item data kasbon
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(list[i].status, style: TextStyle(fontSize: 20, color: Colors.greenAccent, fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Nama : ", style: TextStyle(fontSize: 20),),
                    Text(list[i].nama, style: TextStyle(fontSize: 20),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("No Kontak : ", style: TextStyle(fontSize: 20),),
                    Text(list[i].kontak, style: TextStyle(fontSize: 20),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total Harga : ", style: TextStyle(fontSize: 20),),
                    Text(list[i].totalHarga, style: TextStyle(fontSize: 20),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Jatuh Tempo : ", style: TextStyle(fontSize: 20),),
                    Text(jt[0], style: TextStyle(fontSize: 20),)
                  ],
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}