import 'package:ostor_project/Auth.dart';

import 'Saved.dart';
import 'Sell.dart';
import 'UserProfile.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin{

  late TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(icon: Image.asset("asset/1.png", height: 30,width: 30,)),
    Tab(icon: Image.asset("asset/2.png", height: 30,width: 30,)),
    Tab(icon: Image.asset("asset/3.png", height: 30,width: 30,)),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
  }

  Widget menu(){
    return TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      onTap: (value) {},
      controller: _controller,
      tabs: list,
      indicatorColor: Colors.lightGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: false,
        title:Container(
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 30,
                  height: 30,
                  child: Image.asset("asset/logo.png")

              ),
              Container(
                  child: Text("Warung MakIjah", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
              ),
              InkWell(
                child: Container(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.supervised_user_circle_outlined,size: 30,color: Colors.black)
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Auth()));
                },
              )
            ],
          ),
        )
      ),
      body: TabBarView(controller: _controller, children: [
        Center(
            child: Text(
              _selectedIndex.toString(),
              style: TextStyle(fontSize: 40),
            )),
        //Saved(),
        //Sell(),
      ]
      ),
      bottomNavigationBar: menu(),

    );
  }
}
