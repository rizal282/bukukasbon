import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:buku_kasbon/helper/duedatehelper.dart';
import 'package:flutter/material.dart';

class DueDate extends StatefulWidget {
  @override
  _DueDateState createState() => _DueDateState();
}

class _DueDateState extends State<DueDate> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Telat Bayar"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: FutureBuilder(
          future: db.getDuedate(),
          builder: (context, snapshot){
            if(snapshot.hasError)
              print(snapshot.error);

            return ItemDueDate(snapshot.data);
          },
        ),
      ),
    );
  }
}

class ItemDueDate extends StatelessWidget {
  final List<DuedateHelper> listItem;

  ItemDueDate(this.listItem);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItem == null ? 0 : listItem.length,
      itemBuilder: (context, i){
        var tglTempo = listItem[i].tglTempo.split(" ");
        var tglBayar = listItem[i].tglBayar.split(" ");

        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(listItem[i].nama),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Tgll Tempo : ${tglTempo[0]}"),

                Text("Tgl Tempo : ${tglBayar[0]}"),
              ],
            ),
          ),
        );
      },
    );
  }
}

