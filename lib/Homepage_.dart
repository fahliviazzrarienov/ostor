import 'dart:io';

import 'package:ostor_project/Database_Helper_Onsale.dart';

import 'Database_Helper.dart';
import 'Databasehelper_sell.dart';
import 'Saved.dart';
import 'Sell.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth.dart';
import 'UserProfile.dart';

class Homepage_ extends StatefulWidget {

  Homepage_({Key? key, required this.store, required this.icon}) : super(key: key);
  String store, icon;

  @override
  State<Homepage_> createState() => _Homepage_State();
}

class _Homepage_State extends State<Homepage_> {
  List<Map<String, dynamic>> myData = [];

  Future<void> show() async {
    final data = await DatabaseHelper_Sell.getItems();
    setState(() {
      myData = data;
    });
  }

  @override
  void initState() {
    show();
    super.initState();
  }

  Future<void> deleteAccount()async {
    Widget cancelButton = TextButton(
      child: Text("Tidak", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Keluar", style: TextStyle(color: Colors.red),),
      onPressed: ()  {
        setState(() async {
          await DatabaseHelper_Sell.deleteall();
          await DatabaseHelper.deleteall();
          await DatabaseHelper_OnSale.deleteall();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('store');
          prefs.remove('icon');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil Keluar Dan Data Anda Sepenuhnya Hilang!', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          ));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => Auth()));
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Maka semua data anda di sini akan terhapus",style: TextStyle(color: Colors.black),),
      title: Text("Apakah anda yakin ingin keluar akun ?",style: TextStyle(color: Colors.black),),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title:Container(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 30,
                    height: 30,
                    child: InkWell(child: Image.file(fit: BoxFit.cover, File(widget.icon)),onTap: (){deleteAccount();},)

                ),
                Container(
                    child: Text(widget.store, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.white),)
                ),
                InkWell(
                  child: Container(
                      width: 30,
                      height: 30,
                      child: Icon(Icons.shopping_bag,size: 30,color: myData.isEmpty ? Colors.white : Colors.yellowAccent)
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Sell(icon:  widget.icon, store: widget.store)));
                      },

                )
              ],
            ),
          )
      ),
      body: Saved(icon:  widget.icon, store: widget.store),
    );
  }
}
