import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text("Menu Pemilik Folder")
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container( child: Icon(Icons.supervised_user_circle_outlined, size: 60, ), width: 60, height: 60, ),
                    Container( child: Column(
                      children: [
                        Text("Username", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Text("Username", style: TextStyle(fontSize: 15),),
                      ],
                    ),),
                    Container(margin: EdgeInsets.all(10),child: Icon(Icons.settings_sharp),)
                  ],
                ),
              ),
              Container( width: double.infinity,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.grey)), margin: EdgeInsets.only(left: 10,right: 10, top: 10), child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin:EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset('asset/cal.png', width: 30, height: 30,),
                        SizedBox(width: 10,),
                        Text("Rp.0000", style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    )
                  ),
                  Container(
                      margin:EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text("0", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),
                          Image.asset('asset/item.png', width: 30, height: 30,),
                        ],
                      )
                  )
                ],
              ),),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10, top: 30),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child:Text("Aktivitas Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.left,),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Row(
                        children: [
                          Container(child: Icon(Icons.monetization_on_outlined,color: Colors.black, size: 20,),),
                          SizedBox(width: 10,),
                          Container(child: Text("Aktivitas Keuangan"))
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Row(
                        children: [
                          Container(child: Icon(Icons.library_books_outlined,color: Colors.black, size: 20,),),
                          SizedBox(width: 10,),
                          Container(child: Text("Aktivitas Item"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10, top: 30),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child:Text("Tentang Kami", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.left,),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Row(
                        children: [
                          Container(child: Icon(Icons.help_outline_rounded,color: Colors.black, size: 20,),),
                          SizedBox(width: 10,),
                          Container(child: Text("Blog Kami"))
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Row(
                        children: [
                          Container(child: Icon(Icons.report_gmailerrorred_rounded,color: Colors.black, size: 20,),),
                          SizedBox(width: 10,),
                          Container(child: Text("Saran Kritik"))
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Row(
                        children: [
                          Container(child: Icon(Icons.adjust_outlined,color: Colors.black, size: 20,),),
                          SizedBox(width: 10,),
                          Container(child: Text("Petunjuk Penggunaan"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50,),
              InkWell(
                onTap: (){},
                child: Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.grey)),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center, ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
