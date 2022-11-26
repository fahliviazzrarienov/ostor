import 'package:flutter/material.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordconfirm = TextEditingController();

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
      margin: EdgeInsets.only(top:10,left: 10,right: 10,bottom: 30),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(Icons.circle, size: 10,),
            Image.asset("asset/google.png",height: 20,width: 20,),
            SizedBox(width: 20,),
            Text("Daftar dengan Google", style: TextStyle(fontSize: 15),),
          ],
        ),
      ),
    );
  }

  Widget button(String label){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10,),
      child: ElevatedButton(onPressed: (){}, child: Text(label,style: TextStyle(), textAlign: TextAlign.center,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                child: Image.asset("asset/sign_up.png",  width: 200,),
              ),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 30, ),
                child: Text("Daftar", textAlign: TextAlign.left,style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, ),),
              ),
              editText("Alamat email", email, Icon(Icons.email_outlined)),
              editText("Nama Panjang", email, Icon(Icons.person)),
              editText("Kata Sandi Baru", password, Icon(Icons.lock_outline)),
              editText("Konfirmasi Kata Sandi", passwordconfirm, Icon(Icons.lock_open)),
              button("Masuk"),
              SizedBox(height: 10,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       color: Colors.black54,
              //       height: 1,
              //       width: 100,
              //     ),
              //     SizedBox(width: 10,),
              //     Text("Atau"),
              //     SizedBox(width: 10,),
              //     Container(
              //       color: Colors.black54,
              //       height: 1,
              //       width: 100,
              //     ),
              //   ],
              // ),
              // google(),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah Punya Akun?", style: TextStyle(color: Colors.black),),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                      },
                      child: Text("Masuk", style: TextStyle(color: Colors.blue),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      )
    );
  }
}
