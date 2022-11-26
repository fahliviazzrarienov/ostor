import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ostor_project/Database_Helper_Onsale.dart';

import 'Databasehelper_sell.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database_Helper.dart';
import 'Homepage_.dart';
import 'Saved.dart';
import 'detail.dart';

class Sell extends StatefulWidget {
  Sell({Key? key, required this.icon, required this.store}) : super(key: key);
  String icon, store;


  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  bool isFavorit = false;
  String? selectedValue, selectedValuecategories;
  bool _isLoading = true;
  List<Map<String, dynamic>> myDataSell = [];
  double moneyone=0, moneyall=0, amount=0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceoneController = TextEditingController();
  final TextEditingController _priceallController = TextEditingController();
  final TextEditingController _total = TextEditingController();
  final TextEditingController _codever = TextEditingController();
  final TextEditingController _urmoney = TextEditingController();
  final TextEditingController _allhas = TextEditingController();
//=============================================//


  void _refreshData() async {
    final data = await DatabaseHelper_Sell.getItems();
    setState(() {
      myDataSell = data;
      _isLoading = false;
      _total.text = moneyFormatzero(sumSell().toString());
      _codever.text= koderandom();
    });
  }

  Future<void> verivy(int index, int id) async {
    Widget cancelButton = TextButton(
      child: Text("Tidak", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Verifikasi", style: TextStyle(color: Colors.green),),
      onPressed: () async {
          await DatabaseHelper_OnSale.createItem(_codever.text,toDouble(_total.text));
          List<Map<String, dynamic>> have = await DatabaseHelper.getItem(id);
          String priceallbfr = have[index]['priceall'];
          String amountbfr = have[index]['amount'];
          double priceall = double.parse(priceallbfr) - double.parse(myDataSell[index]['priceall']);
          double amount = double.parse(amountbfr) - double.parse(myDataSell[index]['amount']);
          await DatabaseHelper.updateItem(id, myDataSell[index]['title'], myDataSell[index]['description'], myDataSell[index]['categories'], amount.toString(), myDataSell[index]['size'], myDataSell[index]['priceone'],priceall.toString());
          await DatabaseHelper_Sell.deleteall();
        setState(() {
          String thiss = myDataSell[index]['priceall'].toString();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Berhasil Dimasukkan Ke Nota! ${thiss}', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          ));
          sumallSellamount =0;
          _codever.text= koderandom();
          _refreshData();
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("KODE TRANSAKSI PELANGGAN ${_codever.text}"),
      content: Container(child: Column(
        children: [
          editText("Jumlah Semua", _total),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5,),
            child: TextField(
              controller: _urmoney,
              style: TextStyle(fontSize: 13),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              decoration: InputDecoration(
                labelText: "Yang Disetorkan",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(width:double.infinity, margin:EdgeInsets.only(left: 10,right: 10),child:ElevatedButton(onPressed: (){double all = double.parse(toDouble(_urmoney.text)) - double.parse(toDouble(_total.text));
          _allhas.text = moneyFormatzero(all.toString());}, child: Text("Kalkulasi")),),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5,),
            child: TextField(
              controller: _allhas,
              style: TextStyle(fontSize: 13),
              enabled: false,
              decoration: InputDecoration(
                labelText: "Kembalian Uangmu",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),),
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
        await DatabaseHelper_Sell.deleteall();
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          ));
          sumallSellamount =0;
          _codever.text= koderandom();
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


  Widget editText(String hint, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5,),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 13),
        enabled: false,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget button(){
    return Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        width: double.infinity,
        child: ElevatedButton(
        style:  ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: BorderSide(color: Colors.green)
    )
    ),
    ),
    onPressed: (){
          for(int i = 0; i <= myDataSell.length; i++){
            verivy(i, myDataSell[i]['idthis']);
          }
    }, child: Text("Verifikasi", style: TextStyle(color: Colors.blueGrey),)));
  }

  Widget calculate(){
    return Container(
        //color: Colors.lightGreen,
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(child: Image.asset("asset/cal.png"), width: 40,height: 30,),
                    SizedBox(width: 5,),
                    Container(child: Text("Rp. 000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),)
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(child: Text("0", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                    SizedBox(width: 5,),
                    Container(child: Image.asset("asset/item.png"), width: 40,height: 30,),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  String rndom="";
  String koderandom(){
    var rnd = new Random();
    var next = rnd.nextInt(1000000);
    rndom = next.toString();
    return rndom;
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
        await DatabaseHelper_Sell.deleteItem(id);
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.white),),
              backgroundColor:Colors.green
          ));
          sumallSellamount =0;
          _codever.text= koderandom();
        });
        Navigator.pop(context);
        _refreshData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus ${name}?",style: TextStyle(color: Colors.black),),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.green)),
        width: double.infinity,
        height: 200,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            editText("Jumlah semua", _total),
            SizedBox(height: 10,),
            editText("Kode Transaksi Pelanggan", _codever),
            SizedBox(height: 10,),
            button(),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Keranjang Penjualan", style: TextStyle(color: Colors.black),),
            IconButton(onPressed: (){
              myDataSell.isEmpty ?
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Tidak ada yang bisa dihapus di keranjang', style: TextStyle(color: Colors.white),),
                  backgroundColor:Colors.green
              )) :
              delete();
            }, icon: Icon(Icons.delete), color: myDataSell.isEmpty ? Colors.black:Colors.red,)
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
    ),

      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : myDataSell.isEmpty?const Center(child:  Text("Tidak ada yang diranjang", style: TextStyle(fontWeight: FontWeight.bold))):  ListView.builder(
            itemCount: myDataSell.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Card(
              color:index%2==0?Colors.white: Colors.white,
              margin: const EdgeInsets.all(15),
              child:ListTile(
                  onTap: (){
                    showMyForm(myDataSell[index]['id']);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(id: myDataSell[index]['id'], store: widget.store,icon: widget.icon,)));
                    //Future.delayed(Duration(seconds: 1));
                  },
                  title: Text(myDataSell[index]['title'], style: TextStyle( color: Colors.black , fontSize: 18, fontWeight: FontWeight.bold), ),
                  subtitle: Text("Rp"+moneyFormat(myDataSell[index]['priceall']), style: TextStyle(color: Colors.black, fontSize: 15,),),
                  trailing:
                  //       IconButton(
                  //         icon: const Icon(Icons.edit,color: Colors.deepOrangeAccent,size: 25,),
                  //         //onPressed: () => showMyForm(myData[index]['id']),
                  //       ),
                        IconButton(
                          icon: const Icon(Icons.delete,color: Colors.redAccent, size: 25),
                          onPressed: () {
                            deleteItem(myDataSell[index]['id'], myDataSell[index]['title']);
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
  double sumallSellamount =0;
  double sumSell(){
    myDataSell.forEach((element) {sumallSellamount+=double.parse(element['priceall']);});
    //String sumallSllamount = moneyFormat(sumallSellamount.toString()+"00");
    return sumallSellamount;
  }

  void showMyForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingData =
      myDataSell.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
      selectedValuecategories = existingData['categories'];
      _amountController.text = existingData['amount'];
      selectedValue = existingData['size'];
      _priceoneController.text = moneyFormatzero(existingData['priceone']);
      _priceallController.text = moneyFormat(existingData['priceall']);
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // prevent the soft keyboard from covering the text fields
            bottom: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              editText("Masukkan Nama Barang", _titleController),
              const SizedBox(
                height: 10,
              ),
              editText("Masukkan Deskripsi Barang", _descriptionController),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, ),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pilih Kategori',
                    ),
                    validator: (value) => value == null ? "pilih ukuran" : null,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    value: selectedValuecategories,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValuecategories = newValue!;
                      });
                    },
                    items: dropdowncategories),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right:10,top: 5, ),
                child: TextField(
                  style: TextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Masukkan Jumlah Barang',
                    border: OutlineInputBorder(),
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, ),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pilih Ukuran',
                    ),
                    validator: (value) => value == null ? "pilih ukuran" : null,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                child:TextField(
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Harga Barang Persatuan',
                    border: OutlineInputBorder(),
                  ),
                  controller: _priceoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyFormat()
                  ],
                ),
              ),Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, ),
                child:TextField(
                  // onChanged: (value){
                  //   _priceallController.text = moneyFormat(_priceallController.text);
                  //   moneyall = double.parse(_priceallController.text);
                  //
                  // },
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Harga Barang Persemua',
                    border: OutlineInputBorder(),
                  ),
                  controller: _priceallController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyFormat()
                  ],
                ),
              ),


              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                width: double.infinity,
                child: ElevatedButton(
                  style:  ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.green)
                          )
                      )
                  ),
                  onPressed: () async {
                    // Save new data
                    // if (id == null) {
                    //   await addItem();
                    // }
                    //
                    // if (id != null) {
                    //   await updateItem(id);
                    // }


                    // Clear the text fields
                    _titleController.text = '';
                    _descriptionController.text = '';
                    _amountController.text='';
                    _priceoneController.text='';
                    _priceallController.text='';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Buat Baru' : 'Perbarui', style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ));
  }

  List<DropdownMenuItem<String>> dropdownItems= [
    DropdownMenuItem(child: Text("Gram"),value: "Gram"),
    DropdownMenuItem(child: Text("Meter"),value: "Meter"),
    DropdownMenuItem(child: Text("Liter"),value: "Liter"),
    DropdownMenuItem(child: Text("Buah"),value: "Buah"),
    DropdownMenuItem(child: Text("Pak"),value: "Pak"),
  ];

  List<DropdownMenuItem<String>> dropdowncategories= [
    DropdownMenuItem(child: Text("Makanan"),value: "Makanan"),
    DropdownMenuItem(child: Text("Obat - Obatan"),value: "Obat - Obatan"),
    DropdownMenuItem(child: Text("Elektronik"),value: "Elektronik"),
    DropdownMenuItem(child: Text("Pakaian"),value: "Pakaian"),
    DropdownMenuItem(child: Text("Alat Belajar"),value: "Alat Belajar"),
    DropdownMenuItem(child: Text("Permainan"),value: "Permainan"),
    DropdownMenuItem(child: Text("Berbahaya"),value: "Berbahaya"),
    DropdownMenuItem(child: Text("Perabot"),value: "Perabot"),
    DropdownMenuItem(child: Text("Inventaris rumah"),value: "Inventaris rumah"),
    DropdownMenuItem(child: Text("Lainnya"),value: "Lainnya"),
  ];

  String moneyFormat(String value) {
    String k = value;
    var k1 = k.replaceAll('.', '');
    double k2 = double.parse(k1);
    final formatter = new NumberFormat.simpleCurrency(name: "",decimalDigits: 2);
    String newText = formatter.format(k2/100);
    return newText;
  }

  String moneyFormatzero(String value) {
    String k = value+"0";
    var k1 = k.replaceAll('.', '');
    double k2 = double.parse(k1);
    final formatter = new NumberFormat.simpleCurrency(name: "",decimalDigits: 2);
    String newText = formatter.format(k2/100);
    return newText;
  }

  String toDouble(String value){
    var k1 = value.replaceAll(',', '');
    return k1.toString();
  }

  String toDoublenotzero(String value){
    var k1 = value.replaceAll(',', '');
    var k2 = double.parse(k1)/1;
    return k2.toString();
  }
}
