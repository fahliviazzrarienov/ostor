import 'dart:ffi';
import 'dart:io';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:ostor_project/Database_Helper_Onsale.dart';
import 'package:ostor_project/onsale..dart';

import 'Databasehelper_sell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'Database_Helper.dart';
import 'Sell.dart';
import 'detail.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key, required this.store, required this.icon}) : super(key: key);
  final String store, icon;

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {

  bool isFavorit = false;
  String? selectedValue, selectedValuecategories;

  List<Map<String, dynamic>> myData = [];
  List<Map<String, dynamic>> myDataFilter = [];
  List<Map<String, dynamic>> myDataSell = [];

  double moneyone=0, moneyall=0, amount=0;
   int sumallamount=0;
  String? searchString;

  bool _isLoading = true;
  // This function is used to fetch all data from the database

  TextEditingController search = TextEditingController();

  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    final datasell = await DatabaseHelper_OnSale.getItems();
    setState(() {
      myData = data;
      myDataSell = datasell;
      _isLoading = false;
    });
  }

  showDeleteDialog(BuildContext context, int id) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Tidak", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Hapus", style: TextStyle(color: Colors.red),),
      onPressed: () async {
        await DatabaseHelper.deleteItem(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.black),),
            backgroundColor:Colors.lightGreen
        ));
        sumallSaveamount =0;
        sumallSellamount=0;
        _refreshData();
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus?",style: TextStyle(color: Colors.black),),
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
    //_foundData = myData;
    _refreshData();
    super.initState();
     // Loading the data when the app starts
  }

  Widget editText(String hint, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5,),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
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


  int allSumDataAmount(){
    for(int i =1; i <= myData.length ; i++ ){
        sumallamount = i;
    }

    return sumallamount;
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceoneController = TextEditingController();
  final TextEditingController _priceallController = TextEditingController();
  final TextEditingController _priceallSellController = TextEditingController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController priceoneController = TextEditingController();
  final TextEditingController priceallController = TextEditingController();


  void addSell(int id,String title, String description, String categories,String priceall,String priceone,String maxthis,String size) {
    double max, allprice, maxint;
    maxint = double.parse(maxthis);
    if(maxint == 1){
      max = 1;
    }else {
      max = maxint / 2;
    }
    allprice=double.parse(priceone)*max;
    _priceallSellController.text = moneyFormat(allprice.toString());
    setState(() {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
                width: double.infinity,
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
                    SizedBox(height: 10),
                    SpinBox(
                      decimals: 1,
                      step: 0.1,
                      min: 1,
                      max: maxint,
                      value: max,
                      decoration: InputDecoration(labelText: 'Jumlah Barang'),
                      onChanged: (value) {
                        setState(() {
                          sumallSaveamount =0;
                          sumallSellamount=0;
                          max = value;
                          allprice=double.parse(priceone)*max;
                          _priceallSellController.text = moneyFormat(allprice.toString());
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pilih Ukuran',
                        ),
                        dropdownColor: Colors.green,
                        value: size,
                        onChanged: (String? newValue) {
                          sumallSaveamount =0;
                          sumallSellamount=0;
                          setState(() {
                            selectedValue = newValue!;
                          });},
                        items: dropdownItems),
                    const SizedBox(
                      height: 10,
                    ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child:TextField(
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Total Semua',
                      border: OutlineInputBorder(),
                    ),
                    controller: _priceallSellController,
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
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.green)
                                )
                            )
                        ),
                        onPressed: ()  async {
                          // double result = double.parse(maxthis) - max;
                          // double totalresult = double.parse(priceall)- double.parse(toDouble(_priceallSellController.text));
                          await DatabaseHelper.updateItem(id, title, description, categories, maxthis, selectedValue, priceone, priceall);
                          await DatabaseHelper_Sell.createItem(id, title, description, categories, max.toString(), selectedValue, priceone, toDouble(_priceallSellController.text));
                          sumallSaveamount =0;
                          sumallSellamount=0;
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(max.toString()+selectedValue.toString())));
                            Navigator.of(context).pop();
                          });
                          _refreshData();
                        }, child: Text("Taruh Dilaman Jual", style: TextStyle(color: Colors.blueGrey),),
                      ),
                    )
                  ],
                ));
          },);
      });
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  Future<void> showMyForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingData =
      myData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
      selectedValuecategories = existingData['categories'];
      _amountController.text = existingData['amount'];
      selectedValue = existingData['size'];
      _priceoneController.text = moneyFormat(existingData['priceone']);
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
              const SizedBox(
                height: 10,
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
                  inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,]
                ),
              ),
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 10,
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
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                    if (id == null) {
                      await addItem();
                    }

                    if (id != null) {
                      await updateItem(id);
                    }


                    // Clear the text fields
                    _titleController.text = '';
                    _descriptionController.text = '';
                    _amountController.text='';
                    _priceoneController.text='';
                    _priceallController.text='';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                    sumallSaveamount = 0;
                    sumallSellamount=0;
                  },
                  child: Text(id == null ? 'Buat Baru' : 'Perbarui', style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ));
  }

// Insert a new data to the database
  Future<void> addItem() async {
    setState(() {
      if(_priceoneController.text.isEmpty){
        moneyone=double.parse(toDouble(_priceallController.text))/double.parse(_amountController.text);
        moneyall = double.parse(toDouble(_priceallController.text));
        _priceallController.text=moneyall.toString();
        _priceoneController.text = moneyone.toString();
      }else if(_priceoneController.text=="0.00"){
        moneyone=double.parse(toDouble(_priceallController.text))/double.parse(_amountController.text);
        moneyall = double.parse(toDouble(_priceallController.text));
        _priceallController.text=moneyall.toString();
        _priceoneController.text = moneyone.toString();
      }else if(_priceallController.text.isEmpty){
        moneyall=double.parse(_amountController.text)*double.parse(toDouble(_priceoneController.text));
        moneyone = double.parse(toDouble(_priceoneController.text));
        _priceoneController.text=moneyone.toString();
        _priceallController.text = moneyall.toString();
      }else if(_priceallController.text=="0.00"){
        moneyall=double.parse(_amountController.text)*double.parse(toDouble(_priceoneController.text));
        moneyone = double.parse(toDouble(_priceoneController.text));
        _priceoneController.text=moneyone.toString();
        _priceallController.text = moneyall.toString();
      }else{
        moneyone =double.parse(toDouble(_priceoneController.text));
        moneyall =double.parse(toDouble(_priceallController.text));
        _priceoneController.text = moneyone.toString();
        _priceallController.text = moneyall.toString();
      }
    });
    await DatabaseHelper.createItem(
        _titleController.text, _descriptionController.text,selectedValuecategories, _amountController.text,selectedValue,_priceoneController.text,_priceallController.text);
    _refreshData();
  }

  // Future<void> addItemSell() async {
  //   moneyall = amount*moneyone;
  //   _amountController.text = moneyall.toString();
  //   await DatabaseHelper_Sell.createItem(
  //       _titleController.text, _descriptionController.text, selectedValuecategories,_amountController.text,selectedValue,_priceoneController.text,_priceallController.text);
  //   _refreshData();
  // }

  // Update an existing data
  Future<void> updateItem(int id) async {
    setState(() {
      if(_priceoneController.text.isEmpty){
        moneyone=double.parse(toDouble(_priceallController.text))/double.parse(_amountController.text);
        moneyall = double.parse(toDouble(_priceallController.text));
        _priceallController.text=moneyall.toString();
        _priceoneController.text = moneyone.toString();
      }else if(_priceoneController.text=="0.00"){
        moneyone=double.parse(toDouble(_priceallController.text))/double.parse(_amountController.text);
        moneyall = double.parse(toDouble(_priceallController.text));
        _priceallController.text=moneyall.toString();
        _priceoneController.text = moneyone.toString();
      }else if(_priceallController.text.isEmpty){
        moneyall=double.parse(toDouble(_priceoneController.text))*double.parse(_amountController.text);
        moneyone = double.parse(toDouble(_priceoneController.text));
        _priceallController.text = moneyall.toString();
        _priceoneController.text=moneyone.toString();
      }else if(_priceallController.text=="0.00"){
      moneyall=double.parse(toDouble(_priceoneController.text))*double.parse(_amountController.text);
      moneyone = double.parse(toDouble(_priceoneController.text));
      _priceallController.text = moneyall.toString();
      _priceoneController.text=moneyone.toString();
      }else{
        moneyone =double.parse(toDouble(_priceoneController.text));
        moneyall =double.parse(toDouble(_priceallController.text));
      _priceoneController.text = moneyone.toString();
      _priceallController.text = moneyall.toString();
      }

    });
    await DatabaseHelper.updateItem(
        id, _titleController.text, _descriptionController.text, selectedValuecategories,_amountController.text,selectedValue,_priceoneController.text,_priceallController.text);
    _refreshData();
  }

  // Delete an item
  Future<void> deleteItem(int id) async
  {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.black),),
        backgroundColor:Colors.lightBlueAccent
    ));
    _refreshData();
  }




  Widget edittextsearch(TextEditingController controller, String hint){
    return Container(
      width: 10,
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.search),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
        ),
        onFieldSubmitted: (s) {
          myDataFilter.clear();
          if (s.isNotEmpty) {
            myDataFilter = myData.where((data) => data['title'].toLowerCase().contains(s.toLowerCase())).toList();
          } else {
            myDataFilter = myData;
          }
          print('${myDataFilter}');
        },
      )

    );
  }
  double sumallSellamount=0;
  double sumallSaveamount=0;

  double sumSell(){
    myDataSell.forEach((element) {sumallSellamount+=double.parse(element['priceall']);});
    //String sumallSllamount = moneyFormat(sumallSellamount.toString()+"00");
    return sumallSellamount;
  }

  double sumSave(){
    myData.forEach((element) {sumallSaveamount+=double.parse(element['priceall']);});
    //String sumallSllamount = moneyFormat(sumallSaveamount.toString()+"00");
    return sumallSaveamount;
  }

  List<Map<String, dynamic>> _foundData = [];
  Widget calculate(){
    return Container(
      color: Colors.green,
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10, bottom: 100),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteSell(icon:  widget.icon, store: widget.store),));
                  },
                  child: Container(
                    width: 80,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Container(child: Icon(Icons.attach_money_outlined, color: Colors.white, size: 30,), width: 40,height: 30,),
                        // SizedBox(width: 1,),
                        Container(child: Text("Uang Dikantong", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.black),textAlign: TextAlign.center),),
                        SizedBox(height: 10,),
                        Container(child: Text('Rp'+moneyFormat(sumSell().toString()), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),maxLines: 5, textAlign: TextAlign.center),),
                      ],
                    ),
                  )
                ),
                Container(height: 20, width: 1,color: Colors.black),
                Container(
                  width: 80,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(child: Text("Barang Diloker", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),textAlign: TextAlign.center),),
                      SizedBox(height: 10,),
                      Container(child: Text(allSumDataAmount().toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),maxLines: 5, textAlign: TextAlign.center),),
                      // SizedBox(width: 5,),
                      // Container(child: Image.asset("asset/item.png"), width: 40,height: 30,),
                    ],
                  ),
                ),
                Container(height: 20, width: 1,color: Colors.black),
                Container(
                  width: 80,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(child: Text("Uang Modal", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),textAlign: TextAlign.center),),
                      SizedBox(height: 10,),
                      Container(child: Text("Rp"+moneyFormat(sumSave().toString()), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),maxLines: 5, textAlign: TextAlign.center),)
                    ],
                  ),
                )
              ],
            ),
          )
          )
    );
  }
  String moneyFormat(String value) {
    String k = value+"0";
    var k1 = k.replaceAll('.', '');
    double k2 = double.parse(k1);
    final formatter = new NumberFormat.simpleCurrency(name: "",decimalDigits: 2);
    String newText = formatter.format(k2/100);
    return newText;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.folder_copy_outlined, color: Colors.white,),
        onPressed: (){
          showMyForm(null);
        },
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              child: calculate(),
            ),
      Padding(
          padding: const EdgeInsets.only(top: 107),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Flexible(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(child: Text("Loker Sedia",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                        Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              child: edittextsearch(search, "Cari Barangmu"),
                            )
                        )
                      ],
                    ),),
                    SafeArea(
                      child: //search.text.toLowerCase().isNotEmpty ?
                      _isLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : myData.isEmpty
                          ? const Center(child:  Text("Belum ada data disini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
                          : ListView.builder(
                        itemCount: myData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          color:index%2==0?Colors.white: Colors.white,
                          margin: const EdgeInsets.all(15),
                          child:ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(id: myData[index]['id'],icon: widget.icon, store: widget.store,)));
                                Future.delayed(Duration(seconds: 1));
                              },
                              title: Text(myData[index]['title'], style: TextStyle( color: Colors.black , fontSize: 18, fontWeight: FontWeight.bold), ),
                              subtitle: Text("Rp"+moneyFormat(myData[index]['priceall']), style: TextStyle(color: Colors.black, fontSize: 15,),),
                              trailing: SizedBox(
                                width: 150,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,color: Colors.green,size: 25,),
                                      onPressed: () => showMyForm(myData[index]['id']),
                                    ),
                                    IconButton(
                                        icon: const Icon(Icons.delete,color: Colors.green, size: 25),
                                        onPressed: () =>
                                            showDeleteDialog(context, myData[index]['id'])
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.sell,color: Colors.green,size: 25,),
                                      onPressed: () {
                                        sumallSaveamount =0;
                                        sumallSellamount=0;
                                        addSell(myData[index]['id'],myData[index]['title'],myData[index]['description'],myData[index]['categories'],myData[index]['priceall'],myData[index]['priceone'],myData[index]['amount'],myData[index]['size']);
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      )
                    )
                  ],
                )
              ),
            ),
          ))],
        )
      ),
    );
  }

}

String toDouble(String value){
  var k1 = value.replaceAll(',', '');
  return k1.toString();
}

class CurrencyFormat extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat.simpleCurrency(name: "",decimalDigits: 2);
    String newText = formatter.format(value/100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}



