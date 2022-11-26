import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostor_project/Database_Helper_Onsale.dart';
import 'Homepage_.dart';
import 'Databasehelper_sell.dart';

class NoteSell extends StatefulWidget {
  const NoteSell({Key? key,required this.store,required this.icon}) : super(key: key);
  final String icon, store;
  @override
  State<NoteSell> createState() => _NoteSellState();
}

class _NoteSellState extends State<NoteSell> {
  List<Map<String, dynamic>> myData = [];
  List<Map<String, dynamic>> myDataNote = [];
  bool _isLoading = true;

  void _refreshData() async {
    final data = await DatabaseHelper_OnSale.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  Future<void> delete() async {
    Widget cancelButton = TextButton(
      child: Text("Tidak", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Hapus", style: TextStyle(color: Colors.red),),
      onPressed: () async {
        await DatabaseHelper_OnSale.deleteall();
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          ));
        });
        Navigator.pop(context);
        _refreshData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus semua keranjang penjualan?",style: TextStyle(color: Colors.black),),
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

  Future<void> deleteItem(int id, String name) async {
    Widget cancelButton = TextButton(
      child: Text("Tidak", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Hapus", style: TextStyle(color: Colors.red),),
      onPressed: () async {
        await DatabaseHelper_OnSale.deleteItem(id);
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          ));
        });
        Navigator.pop(context);
        _refreshData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus nota kode ${name}?",style: TextStyle(color: Colors.black),),
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
  void initState() {
    _refreshData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Keranjang Penjualan", style: TextStyle(color: Colors.black),),
        IconButton(onPressed: (){
          myData.isEmpty ?
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Tidak ada yang bisa dihapus di keranjang', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          )) :
          delete();
        }, icon: Icon(Icons.delete), color: myData.isEmpty ? Colors.black:Colors.red,)
      ],
    ),
    leading: GestureDetector(
    child: Icon(
    Icons.arrow_back,
    color: Colors.black,
    ),
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) => Homepage_(store: widget.store, icon: widget.icon),));
      },
    )),
        body: SingleChildScrollView(
    child: SafeArea(
    child: _isLoading
        ? const Center(
        child: CircularProgressIndicator(),
    )
        : myData.isEmpty?const Center(child:  Text("Tidak ada yang diranjang", style: TextStyle(fontWeight: FontWeight.bold))):  ListView.builder(
    itemCount: myData.length,
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (context, index) => Card(
    color:index%2==0?Colors.white: Colors.white,
    margin: const EdgeInsets.all(15),
    child:ListTile(
    onTap: (){
    //showMyForm(myData[index]['id']);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(id: myDataSell[index]['id'], store: widget.store,icon: widget.icon,)));
    //Future.delayed(Duration(seconds: 1));
    },
    title: Text(myData[index]['title'], style: TextStyle( color: Colors.black , fontSize: 18, fontWeight: FontWeight.bold), ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Text("Rp"+moneyFormat(myData[index]['priceall']), style: TextStyle(color: Colors.black, fontSize: 15,),),
        SizedBox(height: 5,),
        Text(myData[index]['createdAt'], style: TextStyle(color: Colors.black, fontSize: 15,),),
      ],
    ),
    trailing:
    //       IconButton(
    //         icon: const Icon(Icons.edit,color: Colors.deepOrangeAccent,size: 25,),
    //         //onPressed: () => showMyForm(myData[index]['id']),
    //       ),
    IconButton(
    icon: const Icon(Icons.delete,color: Colors.redAccent, size: 25),
    onPressed: () {
    deleteItem(myData[index]['id'], myData[index]['title']);
    }
    ),
    //       IconButton(
    //         onPressed: () {
    //           isFavorit = false;
    //           //isFavorit ? true : false;
    //         },
    //         icon: isFavorit ? Icon(Icons.sell,color: Colors.redAccent,size: 25,) : Icon(Icons.sell_outlined,color: Colors.redAccent,size: 25,),
    //         //deleteItem(myData[index]['id']),
    //       ),


    ),
    ),
    ),
    ),
    ),
    );

  }

  String moneyFormat(String value) {
    String k = value;
    var k1 = k.replaceAll('.', '');
    double k2 = double.parse(k1);
    final formatter = new NumberFormat.simpleCurrency(name: "",decimalDigits: 2);
    String newText = formatter.format(k2/100);
    return newText;
  }
}
