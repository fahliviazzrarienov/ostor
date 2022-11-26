import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController email = TextEditingController();

  Widget editText(String hint, TextEditingController controller, Icon icon){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
          //border: OutlineInputBorder(),
          icon: icon,
        ),
      ),
    );
  }
  Widget button(String label){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ElevatedButton(onPressed: (){}, child: Text(label,style: TextStyle(), textAlign: TextAlign.center,)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Lupa Kata Sandi")),
      body: Container(
        margin:EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.center,
              child: Image.asset("asset/forgot_pw.png",  width: 200,),
            ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10),
              child: Text("Lupa Kata Sandi ?", textAlign: TextAlign.left,style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10, top: 5, right: 20),
              child: Text("Lupa kata sandi ? jangan khawatir masukan alamat email atau nomor posel yang terkait dengan akun anda", textAlign: TextAlign.left,style: TextStyle(fontSize: 12, color: Colors.black54 ),),
            ),
            SizedBox(height: 20,),
            editText("Email / nomor ponsel", email, Icon(Icons.email_outlined)),

            button("Kirim"),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );;
  }
}
