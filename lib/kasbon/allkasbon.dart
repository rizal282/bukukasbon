import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:buku_kasbon/helper/kasbonhelper.dart';
import 'package:flutter/material.dart';

class Alldatakasbon extends StatefulWidget {
  @override
  _AlldatakasbonState createState() => _AlldatakasbonState();
}

class _AlldatakasbonState extends State<Alldatakasbon> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.getAllKasbon(),
      builder: (context, snapshot){
        if(snapshot.hasError) print(snapshot.error);

        var data = snapshot.data;

        return snapshot.hasData
        ? ListKasbon(data)
        : Center(child: Text("Tidak ada data"),);
      },
    );
  }
}

class ListKasbon extends StatelessWidget {
  final List<Kasbonhelper> list;

  ListKasbon(this.list);

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
              ],
            ),
          ),
        );
      },
    );
  }
}