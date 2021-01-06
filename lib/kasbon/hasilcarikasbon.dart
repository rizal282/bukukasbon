import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:buku_kasbon/helper/kasbonhelper.dart';
import 'package:flutter/material.dart';

class HasilCariKasbon extends StatefulWidget {
  String dataCari;
  
  HasilCariKasbon(this.dataCari);
  
  @override
  _HasilCariKasbonState createState() => _HasilCariKasbonState();
}

class _HasilCariKasbonState extends State<HasilCariKasbon> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasil Pencarian ${widget.dataCari}"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: db.cariAllKasbon(widget.dataCari),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Center(child: Text("Tidak ditemukan"),);

            return ItemPencarian(snapshot.data);
          },
        ),
      ),
    );
  }
}

class ItemPencarian extends StatelessWidget {
  final List<Kasbonhelper> list;

  ItemPencarian(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i){
        var jt = list[i].jatuhTempo.split(" ");
        return Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text(list[i].id.toString()),
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
                    Text("No HP : ", style: TextStyle(fontSize: 20),),
                    Text(list[i].kontak, style: TextStyle(fontSize: 20),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total Kasbon : ", style: TextStyle(fontSize: 20),),
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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Status Kasbon : ", style: TextStyle(fontSize: 20),),
                    Text(list[i].status, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
