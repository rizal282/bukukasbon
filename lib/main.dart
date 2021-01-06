// file ini adalah file utama ketika project dibuat dengan flutter,
// jika terhapus maka akan error

import 'dart:async';

import 'package:buku_kasbon/login.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp()); // void main ini adalah pintu masuknya, jika hilang atau terhapus akan error

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Buku Kasbon", // nama aplikasi ketika running di ponsel android
      
      theme: ThemeData(  // ini adalah warna dasar aplikasi
        primaryColor: Colors.blueAccent
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // ini adalah homepage nya, kalo di web seperti index.php
    );
  }
}

// dibawah ini adalah struktur kodingan untuk tampilan awal homepage berupa splash screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // method ini untuk memindahkan secara otomatis dari page splashscreen ke page login setelah 5 detik
  void moveTimer() {
    Timer(Duration(seconds: 5), 
    () => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Login())
    ));
  }

  // method ini yg otomatis menjalankan moveTimer()
  @override
  void initState() {
    moveTimer(); // method ini langsung dijalankan otomatis
    super.initState();
  }

  // tampilan ui homepage splash screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Center(
            child: Image.asset("assets/img/Buku_Kasbon_Inti-removebg.png"),
          ),
        ),
      ),
    );
  }
}