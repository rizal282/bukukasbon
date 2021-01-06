import 'package:buku_kasbon/kasbon/addkasbon.dart';
import 'package:buku_kasbon/kasbon/allkasbon.dart';
import 'package:buku_kasbon/kasbon/carikasbon.dart';
import 'package:flutter/material.dart';

// file yang menampilkan data semua kasbon

// class utama
class Datakasbon extends StatefulWidget {
  @override
  _DatakasbonState createState() => _DatakasbonState();
}

// class yg menampilkan data semua kasbon
class _DatakasbonState extends State<Datakasbon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // title page
        title: Text("Data Semua Kasbon"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CariKasbon())
          ),)
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Alldatakasbon(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Addkasbon())
        ),
      ),
    );
  }
}