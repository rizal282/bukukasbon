import 'dart:convert';
import 'dart:io';

import 'package:buku_kasbon/helper/DBHelper.dart';
import 'package:buku_kasbon/helper/deskbrghelper.dart';
import 'package:buku_kasbon/helper/kasbonhelper.dart';
import 'package:buku_kasbon/kasbon/adddeskbarang.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addkasbon extends StatefulWidget {
  @override
  _AddkasbonState createState() => _AddkasbonState();
}

class _AddkasbonState extends State<Addkasbon> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _nama = new TextEditingController();
  final _kontak = new TextEditingController();
  final _deskBarang = new TextEditingController();
  final _totalHarga = new TextEditingController();
  String _tgl = "....";
  String _status;
  String totalKasbon = "....";
  String fotoKasbon;
  File _fileImage;

  // item of status
  static const menuItems = <String>[
    "Lunas",
    "Belum Lunas"
  ];

  final List<DropdownMenuItem<String>> _statusItems = menuItems
  .map(
    (String val) => DropdownMenuItem<String>(
      value: val,
      child: Text(val),
    )
  ).toList();

  void simpanKasbon() async {
    if(_nama.text == "" && _kontak.text == "" && _fileImage == null){
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: Text("Sukses"),
            content: Text("Data Kasbon belum lengkap!"),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("OK"))
            ],
          )
      );
    }else{
      var db = DBHelper();

      // konversi file foto ke string
      List<int> imageBytes = _fileImage.readAsBytesSync();
      fotoKasbon = base64Encode(imageBytes);

      // simpan ke database kasbon
      var datakasbon = Kasbonhelper(_nama.text, _kontak.text, totalKasbon, _tgl, fotoKasbon, _status);

      await db.addKasbon(datakasbon);

      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: Text("Sukses"),
            content: Text("Data Kasbon baru disimpan!"),
            actions: <Widget>[
              FlatButton(onPressed: (){
                resetForm();
                Navigator.of(context).pop();
              }, child: Text("OK"))
            ],
          )
      );
    }
  }

  void hitungtotalkasbon() async {
    var tgl = DateTime.now().toString().split(" ");
    var db = DBHelper();
    List<Deskbrghelper> data = await db.getTotalKasbon(_nama.text, tgl[0]);
    
    setState(() {
      totalKasbon = data[0].subtotal.toString();
    });
  }

  void resetForm(){
    _nama.text = "";
    _kontak.text = "";
    _deskBarang.text = "";
    _totalHarga.text = "";
    _tgl = "...";
  }

  void ambilFotoKamera() async {
    var fileFoto = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1080,
      maxHeight: 1080,
    );

    setState(() {
      _fileImage = File(fileFoto.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Kasbon"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nama,
                validator: (String val){
                  if(val.isEmpty){
                    return "Nama tidak boleh kosong!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nama",
                  hintText: "Masukan nama",
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _kontak,
                keyboardType: TextInputType.number,
                validator: (String val){
                  if(val.isEmpty){
                    return "Kontak tidak boleh kosong!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Kontak",
                  hintText: "Masukan kontak",
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Deskripsi Barang : "),
                  IconButton(icon: Icon(Icons.add), onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Adddeskbarang(nama: _nama.text,))  
                    );
                  })
                ],
              ),
              SizedBox(height: 20,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total Kasbon : "),
                  Text(totalKasbon),
                  IconButton(icon: Icon(Icons.search), onPressed: (){
                    hitungtotalkasbon();
                  })
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Text("Jatuh Tempo : "),
                  Expanded(child: Text(_tgl),),
                  IconButton(icon: Icon(Icons.date_range), onPressed: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1985), lastDate: DateTime(2025))
                    .then((DateTime val){
                      if(val != null){
                        setState(() {
                          _tgl = val.toString();
                        });
                      }
                    });
                  })
                ],
              ),
              SizedBox(height: 20,),
              ListTile(
                title: Text("Status : "),
                trailing: DropdownButton(
                  value: _status,
                  hint: Text("Pilih"),
                  onChanged: ((String newVal){
                    setState(() {
                      _status = newVal;
                    });
                  }),
                  items: _statusItems,
                ),
              ),
              SizedBox(height: 20,),

              // mengambil foto dari kamera
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Foto"),
                  IconButton(icon: Icon(Icons.camera), onPressed: (){
                    // panggil method proses ambil foto
                    ambilFotoKamera();
                  })
                ],
              ),
              SizedBox(height: 20,),

              // menampilkan foto dalam kontainer
              Container(
                child: _fileImage == null
                ? Center(child: Text("Pilih foto"),)
                : Image.file(_fileImage),
              ),
              SizedBox(height: 20,),
              Card(
                elevation: 0,
                color: Colors.blueAccent,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.white,
                    child: Center(
                      child: Text("Simpan", style: TextStyle(fontSize: 18, color: Colors.white),),
                    ),
                    onTap: (){
                      simpanKasbon();
                      // print(DateTime.now().toString());
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