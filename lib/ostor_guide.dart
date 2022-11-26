import 'package:flutter/material.dart';
import 'package:ostor_project/Auth.dart';

class Guide extends StatefulWidget {
  const Guide({Key? key}) : super(key: key);

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb, size: 30, color: Colors.green,),
                    Text("PANDUAN", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20 ),textAlign: TextAlign.center,),
                    Icon(Icons.lightbulb, size: 30, color: Colors.green,),
                  ],
                )
              ),
              box('1. Autentikasi kan toko anda dengan cara masukan nama dan logo toko anda'),
              box('2. Masukan data barang anda, di situ nanti terdapat riwayat pemasukan, item barang yang kamu pilih, dan uang modal nya'),
              box('3. Detail data barang, disitu nanti terdapat, nama barang, deskripsi, item barang, jumlah barang, harga persatuan, dan harga persemua'),
              box('4. Terdapat riwayat customer yang berfungsi sebagai menyimpan data pelanggan'),
              box('5. kode transaksi pelanggan, dan detail jumlah uang barang dan uang yang di setorkan, kemudian verifikasi, data otomatis kesimpan '),
              button("Lanjutkan", Colors.green, Colors.white)
            ],
          ),
        ),
      )
    );
  }

  Widget box(String text){
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        margin: EdgeInsets.only(left: 30, right: 30, top: 20, ),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/logo.png',width: 50, height: 50,),
              SizedBox(width: 20,),
              Container(
                width: 180,
                child: Text(text, style: TextStyle(color: Colors.black, fontSize: 11,),maxLines: 5, textAlign: TextAlign.center),
              )
            ],
          ),
        )
    );
  }

  Widget button(String label, Color buttoncolor,Color textcolor) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttoncolor)),
          child: Text(label, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: textcolor),),onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Auth()));

        },)
    );
  }
}
