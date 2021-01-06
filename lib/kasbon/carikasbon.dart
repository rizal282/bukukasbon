import 'package:buku_kasbon/kasbon/hasilcarikasbon.dart';
import 'package:flutter/material.dart';

class CariKasbon extends StatefulWidget {
  @override
  _CariKasbonState createState() => _CariKasbonState();
}

class _CariKasbonState extends State<CariKasbon> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cariKasbon = new TextEditingController();

  void cari(){
    if(_formKey.currentState.validate()){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HasilCariKasbon(_cariKasbon.text))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Data Kasbon"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _cariKasbon,
                validator: (String val){
                  if(val.isEmpty){
                    return "Masukan nama atau nomor kontak";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Masukan nama atau nomor kontak"
                ),
              ),
              SizedBox(height: 20,),
              RaisedButton(child: Text("Cari"),onPressed: () => cari(),),
            ],
          ),
        ),
      ),
    );
  }
}
