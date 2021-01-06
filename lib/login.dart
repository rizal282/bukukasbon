import 'package:buku_kasbon/adduser.dart'; // package ini untuk mengimport form tambah user
import 'package:buku_kasbon/helper/DBHelper.dart'; // package ini untuk mengimport file yg berkomunikasi dgn database
import 'package:buku_kasbon/helper/usertokohelper.dart'; // package ini diimport untuk handle input data user baru (pembuatan akun yg punya toko)
import 'package:buku_kasbon/kasbon/homekasbon.dart'; // package ini diimport untuk mengarahkan kembali ke hompage
import 'package:flutter/material.dart'; // semua komponen ui flutter ada disini

// class utama file login
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

// class anak dari class utama
class _LoginState extends State<Login> {
  var db = DBHelper(); // inisialisasi class untuk komunikasi dgn database  
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // untuk validasi form input
  final _username = new TextEditingController(); // untuk menangkap value yg diinput user di form
  final _password = new TextEditingController(); // untuk menangkap value yg diinput user di form

  // method untuk memproses login user
  Future<Usertokohelper> doLoginUser() async {
    if(formKey.currentState.validate()){
      Usertokohelper user = await db.loginUser(_username.text, _password.text);
      return user;
    }

    return null;

    /* proses login dilakukan di dalam file dbhelper dalam method login user.
      doLoginUser hanya dipanggil ketika ada event klik tombol login oleh user
     */
  }

  // kode tampilan ui login user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Text("Login", style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Form(key: formKey, child: formElement()),
            
          ],
        ),
      ),
    );
  }

  // element form login
  Widget formElement(){
    return Column(
      children: <Widget>[

        // untuk input username
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Username",
            hintText: "Masukan Username",
          ),
          keyboardType: TextInputType.text,
          controller: _username,
          validator: (String val){
            if(val.isEmpty){
              return "Username masih kosong";
            }

            return null;
          },
        ),
        SizedBox(height: 20,),

        // untuk input password
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Password",
            hintText: "Masukan Password",
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: _password,
          validator: (String val){
            if(val.isEmpty){
              return "Password masih kosong";
            }

            return null;
          },
        ),
        SizedBox(height: 20,),

        // button untuk login
            Card(
              elevation: 0,
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: InkWell(
                  splashColor: Colors.blueAccent,
                  onTap: () async {
                    Usertokohelper user = await doLoginUser();
                    if(user != null){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Homekasbon(user: user,))
                      );
                    }
                  },
                  child: Center(
                    child: Text("Masuk"),
                  ),
                ),
              ),
            ),
        SizedBox(height: 20,),

        // button untuk membuat akun user
            Card(
              elevation: 0,
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: InkWell(
                  splashColor: Colors.blueAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Adduser())
                    );
                  },
                  child: Center(
                    child: Text("Buat Akun"),
                  ),
                ),
              ),
            )
      ],
    );
  }
}