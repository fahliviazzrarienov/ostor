import 'package:flutter/material.dart';
import 'forgotpassword.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Widget editText(String hint, TextEditingController controller, Icon icon){
    return Container(
      margin: EdgeInsets.only(left:10,right: 30,top: 10,bottom: 10),
      child: TextField(
        style: TextStyle(fontSize: 13),
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
          icon: icon,
          //border: OutlineInputBorder(),
        ),
      ),
    );
  }
  
  Widget google(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(165,173,188,55.0),
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(165,173,188,50.0), spreadRadius: 1),
        ],
      ),
      width: double.infinity,
      margin: EdgeInsets.only(top: 10,left: 10,right: 10),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(Icons.circle, size: 10,),
            Image.asset("asset/google.png",height: 20,width: 20,),
            SizedBox(width: 20,),
            Text("Login dengan Google", style: TextStyle(fontSize: 15),),
          ],
        ),
      ),
    );
  }

  Widget button(String label){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10,bottom: 10),
      child: ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(primary: Colors.deepPurple) ,child: Text(label,style: TextStyle(), textAlign: TextAlign.center,)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset("asset/login.png",  width: 150,),
            ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 30, ),
              child: Text("Masuk", textAlign: TextAlign.left,style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, ),),
            ),
            editText("Email / Nama Pengguna", email, Icon(Icons.person, size: 30,)),
            editText("Kata sandi", password, Icon(Icons.lock)),
            Container(
              margin: EdgeInsets.only(right: 10),
              width: double.infinity,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                },
                child: Text("Lupa kata sandi?",textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.blue),),
              ),
            ),
            button("Masuk"),
            SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       color: Colors.black54,
            //       height: 1,
            //       width: 100,
            //     ),
            //     SizedBox(width: 0,),
            //     Text("Atau"),
            //     SizedBox(width: 10,),
            //     Container(
            //       color: Colors.black54,
            //       height: 1,
            //       width: 100,
            //     ),
            //   ],
            // ),
            SizedBox(height: 10,),
            //google(),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum Punya Akun?", style: TextStyle(color: Colors.black),),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                    },
                    child: Text("Daftar", style: TextStyle(color: Colors.blue),),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
