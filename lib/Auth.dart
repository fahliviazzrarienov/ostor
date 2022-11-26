import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'Homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Homepage_.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  TextEditingController storename= TextEditingController();
  TextEditingController username= TextEditingController();
  var imgPath;
  XFile? pickedImage;
  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        setState(() {
          imgPath = pickedImage!.path;
        });
      } else {
        imgPath = Image.asset("asset/logo.png");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No image was selected"),
          ),
        );
      }
    } catch (e) {
      print(e);
      print("error");
    }
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage_(store: storename.text, icon: imgPath)));
  }

  Widget button(String label, Color buttoncolor,Color textcolor) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttoncolor)),
        child: Text(label, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: textcolor),),onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('icon', imgPath);
        prefs.setString('store', storename.text);

        _navigateToNextScreen(context);
      },)
    );
  }

  Widget editText(String hint, TextEditingController controller, Icon icon){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 30,top: 10,bottom: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: hint,
          //border: OutlineInputBorder(),
          icon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
        margin: EdgeInsets.only(left: 30,right: 30),
        child :Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Text("Autentifikasi", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.green),textAlign: TextAlign.center,),
              SizedBox(height: 5,),
              Container(width: double.infinity,height: 1,color: Colors.green),
              SizedBox(height: 20,),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey),
                ),
                child: pickedImage == null ? Center(child: Icon(Icons.storefront_outlined, size: 200, color: Colors.grey,)) : Image.file(File(pickedImage!.path)),
              ),
              SizedBox(height: 15,),
              // Container(
              //   width: double.infinity,
              //   child:Text("Folder Butuh Identitas", style: TextStyle(color: Colors.brown, fontSize: 23, fontWeight: FontWeight.bold,),textAlign: TextAlign.center),
              // ),
              //Container(height: 1,color: Colors.grey, width: 250, ),
              editText("Nama Toko Anda", storename, Icon(Icons.storefront, color: Colors.green,)),
              //editText("Nama Toko Anda", username, Icon(Icons.supervised_user_circle, color: Colors.brown,)),
              InkWell(
                onTap: (){
                  getImage();
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.grey)),
                    child: Container(
                      margin: EdgeInsets.all(3),
                      child: Text("Tambahkan Logo Anda", style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.center, ),
                    )
                ),
              ),
              SizedBox(height: 10,),
              button("Mulai", Colors.green, Colors.white),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    ));
  }
}
