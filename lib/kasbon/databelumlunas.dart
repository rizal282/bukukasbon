import 'package:buku_kasbon/kasbon/datakasbonblmlunas.dart';
import 'package:flutter/material.dart';

// file ini menampilkan data kasbon blm lunas

class Kasbonbelumlunas extends StatefulWidget {
  @override
  _KasbonbelumlunasState createState() => _KasbonbelumlunasState();
}

class _KasbonbelumlunasState extends State<Kasbonbelumlunas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kasbon Belum Lunas"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Datakasbonblmlunas(), // data kasbon blm lunas ditampilkan di class ini
      ),
    );
  }
}