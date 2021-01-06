import 'package:buku_kasbon/helper/usertokohelper.dart'; // untuk handle data input output data user
import 'package:buku_kasbon/kasbon/addkasbon.dart'; // file page tambah kasbon
import 'package:buku_kasbon/kasbon/databelumlunas.dart'; // file page data kasbon yg blm lunas
import 'package:buku_kasbon/kasbon/datakasbon.dart'; // file page data semua kasbon
import 'package:buku_kasbon/kasbon/datalunas.dart'; // file page data kasbon yg sudah lunas
import 'package:buku_kasbon/kasbon/duedate.dart';
import 'package:buku_kasbon/login.dart'; // file page login
import 'package:flutter/material.dart'; // komponen ui flutter

// class utama
class Homekasbon extends StatefulWidget {
  final Usertokohelper user; // variable untuk menangkap data login user

  Homekasbon({@required this.user}); // konstruktor untuk men-set data login user ke variable user diatas
  @override
  _HomekasbonState createState() => _HomekasbonState();
}

// class anak homekasbon
class _HomekasbonState extends State<Homekasbon> {

  // ui homepage kasbon
  @override
  Widget build(BuildContext context) {

    // ini head sidebar yg menampilkan data siapa yg login
    final _drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(widget.user.username),
      accountEmail: Text(widget.user.namaToko),
      currentAccountPicture: CircleAvatar(
        child: Image.asset("assets/img/Buku_Kasbon_Inti-removebg.png"),
        backgroundColor: Colors.white,
      ),
    );

    // ini tampilan menu sidebar di homepage
    final _drawerItems = Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          _drawerHeader,
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),

          // menu untuk akses data semua kasbon
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text("Data Kasbon"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Datakasbon()));
            },
          ),

          // menu untuk akses page tambah kasbon
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text("Tambah Kasbon"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Addkasbon()));
            },
          ),

          // menu untuk akses data kasbon yg sudah lunas
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Kasbon Lunas"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Kasbonlunas()));
            },
          ),

          // menu untuk akses data kasbon yg blm lunas
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Kasbon Belum Lunas"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Kasbonbelumlunas()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Out of Due Date"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DueDate())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {

              // ini pesan yg akan muncul ketika logout diklik
              showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Perhatian"),
                        content: Text("Apakah Anda yakin ingin keluar?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Tidak"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Ya"),
                            onPressed: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => Login())),
                          )
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Kasbon"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Buku Kasbon",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Membantu mencatat kasbon pelanggan Anda!")
          ],
        ),
      ),
      drawer: _drawerItems,
    );
  }
}
