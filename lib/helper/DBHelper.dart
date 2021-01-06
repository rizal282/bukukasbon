import 'dart:io';

import 'package:buku_kasbon/helper/deskbrghelper.dart'; // file helper untuk handling input data deskripsi barang yg dikasbon
import 'package:buku_kasbon/helper/duedatehelper.dart';
import 'package:buku_kasbon/helper/kasbonhelper.dart'; // file helper untuk handling input data kasbon baru
import 'package:buku_kasbon/helper/usertokohelper.dart'; // file helper untuk handling input data user baru (yg punya toko)
import 'package:path/path.dart'; // package untuk menyimpan file database
import 'package:path_provider/path_provider.dart'; // package untuk menyimpan file database
import 'package:sqflite/sqflite.dart'; // package untuk database sqlite

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  // mengambil database
  Future<Database> get db async {
    if(_db != null) return _db; // jika database ada

    _db = await setDb(); // buat database jika belum ada
    return _db;
  }

  // function untuk membuat database
  setDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "dbKasbon");

    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  // function untuk membuat tabel2 yg dibutuhkan dalam aplikasi buku_kasbon
  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE tokoUser(id INTEGER PRIMARY KEY, username TEXT, password TEXT, namaToko TEXT, alamatToko TEXT)"); // membuat tabel toko user (yg punya toko atau admin)
    await db.execute("CREATE TABLE kasbon(id INTEGER PRIMARY KEY, nama TEXT, kontak TEXT, totalHarga TEXT, jatuhTempo TEXT, foto TEXT, status TEXT)"); // membuat tabel kasbon untuk menampung data orang yg kasbon
    await db.execute("CREATE TABLE deskbarang(id INTEGER PRIMARY KEY, nama TEXT, namabarang TEXT, jumlahbarang INT, satuan TEXT, hargapcs INT, subtotal INT, tglinput TEXT)"); // tabel untuk menampung data barang yg diambil kasbon
    await db.execute("CREATE TABLE bayarkasbon(id INTEGER PRIMARY KEY, nama TEXT, jumlahbayar INT, sisakasbon INT, tgltempo TEXT, tglbayar TEXT)"); // tabel untuk me-record data pembayaran kasbon
//    await db.execute("CREATE TABLE duedate(id INTEGER PRIMARY KEY, nama TEXT, tglTempo TEXT)");
    await db.execute("CREATE TABLE blacklist(id INTEGER PRIMARY KEY, nama TEXT, noHp TEXT)");
    print("Database created!");
  }

  // function untuk membuat user baru ketika app sudah diinstall
  Future<int> addUser(Usertokohelper user) async {
    var dbClient = await db;
    var response = await dbClient.insert("tokoUser", user.toMap());
    return response;
  }

  // function untuk melakukan login user
 Future<Usertokohelper> loginUser(String username, String password) async {
    var dbClient = await db;
    String sql = "SELECT * FROM tokoUser WHERE username = '$username' AND password = '$password'";
    var result = await dbClient.rawQuery(sql);

    if(result.length == 0){
      return null;
    }

    return Usertokohelper.map(result.first);
 }

 // function untuk menambah data orang yg kasbon
 Future<int> addKasbon(Kasbonhelper kasbonhelper) async {
   var dbClient = await db;
   var response = await dbClient.insert("kasbon", kasbonhelper.toMap()); // memasukan data yg kasbon kedalam tabel kasbon

   return response;
 }

  // function untuk menambah data deskripsi barang yang diambil kasbon
 Future<void> addDeskBarang(Deskbrghelper deskbrghelper) async {
   var dbClient = await db;
   await dbClient.insert("deskbarang", deskbrghelper.toMap());
 }

  // function untuk mengambil semua data kasbon
 Future<List<Kasbonhelper>> getAllKasbon() async {
   var dbClient = await db; // memanggil database
   List<Map> list = await dbClient.rawQuery("SELECT * FROM kasbon ORDER BY id DESC");
   List<Kasbonhelper> dataKasbon = List();

   for(int i = 0; i < list.length; i ++){
     var kasbon = Kasbonhelper(list[i]["nama"], list[i]["kontak"], list[i]["totalHarga"], list[i]["jatuhTempo"], list[i]["foto"], list[i]["status"]);
     kasbon.setIdKasbon(list[i]["id"]);

     dataKasbon.add(kasbon);
   }

   return dataKasbon;
 }

  Future<List<Kasbonhelper>> cariAllKasbon(String parameter) async {
    var dbClient = await db; // memanggil database
    List<Map> list = await dbClient.rawQuery("SELECT * FROM kasbon WHERE nama = '$parameter' OR  kontak = '$parameter'");
    List<Kasbonhelper> dataKasbon = List();

    for(int i = 0; i < list.length; i ++){
      var kasbon = Kasbonhelper(list[i]["nama"], list[i]["kontak"], list[i]["totalHarga"], list[i]["jatuhTempo"], list[i]["foto"], list[i]["status"]);
      kasbon.setIdKasbon(list[i]["id"]);

      dataKasbon.add(kasbon);
    }

    return dataKasbon;
  }

  // function untuk mengambil data kasbon yg sudah lunas
 Future<List<Kasbonhelper>> getKasbonLunas() async {
   var dbClient = await db; // memanggil database
   List<Map> list = await dbClient.rawQuery("SELECT * FROM kasbon WHERE status = 'Lunas'"); // query untuk mengambil data kasbon belum lunas sesuai status
   List<Kasbonhelper> dataKasbonLunas = List();

    // men-genarate data dan dimasukan kedalam data kasbonhelper
   for(int i = 0; i < list.length; i ++){
     var kasbon = Kasbonhelper(list[i]["nama"], list[i]["kontak"], list[i]["totalHarga"], list[i]["jatuhTempo"], list[i]["jatuhTempo"], list[i]["status"]);
     kasbon.setIdKasbon(list[i]["id"]);

     dataKasbonLunas.add(kasbon);
   }

   return dataKasbonLunas;
 }

  // function untuk mengambil data kasbon yg belum lunas
 Future<List<Kasbonhelper>> getKasbonBlmLunas() async {
   var dbClient = await db; // memanggil database
   List<Map> list = await dbClient.rawQuery("SELECT * FROM kasbon WHERE status = 'Belum Lunas'"); // query untuk mengambil data kasbon belum lunas sesuai status
   List<Kasbonhelper> dataKasbonBlmLunas = List();

    // men-genarate data dan dimasukan kedalam data kasbonhelper
   for(int i = 0; i < list.length; i ++){
     var kasbon = Kasbonhelper(list[i]["nama"], list[i]["kontak"], list[i]["totalHarga"], list[i]["jatuhTempo"], list[i]["foto"], list[i]["status"]);
     kasbon.setIdKasbon(list[i]["id"]);

     dataKasbonBlmLunas.add(kasbon);
   }

   return dataKasbonBlmLunas;
 }

  // function untuk mengambil data detail kasbon yg blm lunas
 Future<List> getDetailKasbonBlmLunas(String nama) async {
    var dbClient = await db; // memanggil database
    var result = await dbClient.rawQuery("SELECT * FROM deskbarang WHERE nama = '$nama'"); // query untuk mengambil dtl kasbon yg belum lunas

    print(result.length);
    return result;
 }

  // function untuk mengambil detail data kasbon
 Future<List> getDetailKasbonLunas(String nama) async {
    var dbClient = await db; // memanggil database
    var result = await dbClient.rawQuery("SELECT * FROM deskbarang WHERE nama = '$nama'"); // query untuk mengambil detail kasbon
    return result;
 }

  // function untuk hapus data kasbon
 Future<int> hapusKasbon(String nama) async {
   var dbClient = await db; // memanggil database
   var response = await dbClient.rawDelete("DELETE FROM kasbon WHERE nama = '$nama'"); // query hapus data kasbon
   return response;
 }

  // menghapus data deskripsi barang yang diambil kasbon
 Future<int> hapusDeskBarang(String nama) async {
   var dbClient = await db; // memanggil database
   var response = await dbClient.rawDelete("DELETE FROM deskbarang WHERE nama = '$nama'"); // query hapus data deskripsi barang
   return response;
 }

  // function untuk menghapus data bayar kasbon
 Future<int> hapusBayarKasbon(String nama) async {
   var dbClient = await db; // memanggil database
   var response = await dbClient.rawDelete("DELETE FROM bayarkasbon WHERE nama = '$nama'"); // query hapus data bayar kasbon
   return response;
 }

// function untuk menghitung total kasbon   
 Future<List<Deskbrghelper>> getTotalKasbon(String nama, String date) async {
   var dbClient = await db; // memanggil database
   List<Map> data = await dbClient.rawQuery("SELECT SUM(subtotal) as subtotal FROM deskbarang WHERE nama = '$nama' AND tglinput = '$date'"); // membuat query perhitungan total kasbon
    List<Deskbrghelper> dataDesk = List();

    // generate data total kasbon kedalam Deskbarang
    for(int i = 0; i < data.length; i ++){
      var deskKasbon = Deskbrghelper(data[i]["nama"], data[i]["namabarang"], data[i]["jumlahbarang"], data[i]["satuan"], data[i]["hargapcs"], data[i]["subtotal"], data[i]["tglinput"]);
      deskKasbon.setId(data[i]["id"]);

      dataDesk.add(deskKasbon);
    }

    return dataDesk;
 }

 Future<List<DuedateHelper>> getDuedate() async {
    var dbClient = await db;
    List<Map> data = await dbClient.rawQuery("SELECT id, nama, tgltempo, tglbayar FROM bayarkasbon");
    List<DuedateHelper> dataDueDate = List();

    for(int i = 0; i < data.length; i ++){
      var duedateItem = DuedateHelper(data[i]["nama"], data[i]["tgltempo"], data[i]["tglbayar"]);
      int id = data[i]["id"];
      duedateItem.setId(id);

      dataDueDate.add(duedateItem);
    }

    return dataDueDate;
 }


}