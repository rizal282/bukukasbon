import 'package:buku_kasbon/kasbon/datakasbonlunas.dart';
import 'package:flutter/material.dart';

// page utama yg menampilkan data kasbon yg lunas
class Kasbonlunas extends StatefulWidget {
  @override
  _KasbonlunasState createState() => _KasbonlunasState();
}

class _KasbonlunasState extends State<Kasbonlunas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kasbon Lunas"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Datakasbonlunas(), // data kasbon lunas ditampilkan di class ini
      ),
    );
  }
}