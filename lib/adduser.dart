import 'package:buku_kasbon/helper/DBHelper.dart'; // package ini diimport untuk meng-handle input output dengan database
import 'package:buku_kasbon/helper/usertokohelper.dart'; // package ini diimport untuk meng-handle input data dari user
import 'package:flutter/material.dart'; // semua komponen ui flutter ada disini

// class utama adduser untuk membuat akun admin toko
class Adduser extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

// class anak dari adduser
class _AdduserState extends State<Adduser> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // untuk proses validasi form input
  
  // variable ini untuk menangkap data yg diinput user dgn menggunakan texteditingcontroller
  final _inpUsername = new TextEditingController();
  final _inpPassword = new TextEditingController();
  final _inpNamaToko = new TextEditingController();
  final _inpAlmtToko = new TextEditingController();

  // method ini untuk me-reset form input
  void resetForm() {
    _inpUsername.text = "";
    _inpPassword.text = "";
    _inpNamaToko.text = "";
    _inpAlmtToko.text = "";
  }

  // proses pembuatan akun admin
  void tambahUser() async {

    // divalidasi terlebih dahulu
    if(formKey.currentState.validate()){
      var db = DBHelper(); // panggil dbhelper untuk handle input output ke database

      // kirim data yg diinput user ke class usertokohelper
      var dataUser = Usertokohelper(_inpUsername.text, _inpPassword.text, _inpNamaToko.text, _inpPassword.text);
      await db.addUser(dataUser);
    }
  }

  // tampilan ui form buat akun admin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Akun User"),
      ),
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20,),

              // untuk input username
              TextFormField(
                controller: _inpUsername,
                validator: (String val){
                  if(val.isEmpty){
                    return "Username tidak boleh kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Masukkan Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),

              // untuk input password
              TextFormField(
                controller: _inpPassword,
                obscureText: true,
                validator: (String val){
                  if(val.isEmpty){
                    return "Password tidak boleh kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Masukkan Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),

              // untuk input nama toko
              TextFormField(
                controller: _inpNamaToko,
                validator: (String val){
                  if(val.isEmpty){
                    return "Nama Toko tidak boleh kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nama Toko",
                  hintText: "Masukkan Nama Toko",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),

              // untuk input alamat user
              TextFormField(
                controller: _inpAlmtToko,
                validator: (String val){
                  if(val.isEmpty){
                    return "Alamat toko tidak boleh kosong";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Alamat Toko",
                  hintText: "Masukkan Alamat Toko",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),

              // button untuk mulai proses pembuatan akun
              Card(
                color: Colors.white70,
                elevation: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.blueAccent,
                    child: Center(
                      child: Text("Buat Akun", style: TextStyle(fontSize: 18),),
                    ),
                    onTap: (){
                      tambahUser(); // panggil method untuk proses buat akun

                      // jika berhasil, tampilkan pesan dibawah ini dgn showDialog
                      showDialog(context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Sukses"),
                          content: Text("Akun sudah dibuat!"),
                          actions: <Widget>[
                            FlatButton(onPressed: (){
                              resetForm();
                              Navigator.of(context).pop();
                            }, child: Text("OK"))
                          ],
                        )
                      );
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