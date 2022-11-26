import 'package:intl/intl.dart';

import 'Homepage_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'Database_Helper.dart';
import 'Databasehelper_sell.dart';
import 'Saved.dart';
import 'Sell.dart';


class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.id, required this.icon, required this.store}) : super(key: key);
  final int id ;
  final String icon, store;


  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> myData = [];
  List<Map<String, dynamic>> myDataSell = [];
  bool isFavorit = false;
  // This function is used to fetch all data from the database

  String? selectedValue, selectedValuecategories;
  double moneyone=0, moneyall=0, amount=0 ,allprice=0;

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
            backgroundColor:Colors.lightGreenAccent
        ));
        Navigator.push(context,MaterialPageRoute(builder: (context) => Homepage_(store: widget.store, icon: widget.icon),));
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

  // Delete an item
  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Berhasil Dihapus!', style: TextStyle(color: Colors.black),),
        backgroundColor:Colors.white
    ));
    Navigator.push(context,MaterialPageRoute(builder: (context) => Homepage_(store: widget.store, icon: widget.icon),));
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

  Widget image(){
    String image = 'this';
    if(categoriesController.text=='Makanan'){
      image = 'asset/detail_asset/foods.png';
    }else if(categoriesController.text=='Obat - Obatan'){
      image = 'asset/detail_asset/medicins.png';
    }else if(categoriesController.text=='Elektronik'){
      image = 'asset/detail_asset/electronics.png';
    }else if(categoriesController.text=='Pakaian'){
      image = 'asset/detail_asset/clothes.png';
    }else if(categoriesController.text=='Alat Belajar'){
      image = 'asset/detail_asset/studies.png';
    }else if(categoriesController.text=='Permainan'){
      image = 'asset/detail_asset/toys.png';
    }else if(categoriesController.text=='Berbahaya'){
      image = 'asset/detail_asset/dangers.png';
    }else if(categoriesController.text=='Perabot'){
      image = 'asset/detail_asset/things.png';
    }else if(categoriesController.text=='Inventaris rumah'){
      image = 'asset/detail_asset/househelp.png';
    }
    return Image.asset(image);
  }

  @override
  void initState() {
    showrefresh();

    super.initState();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController priceoneController = TextEditingController();
  final TextEditingController priceallController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceoneController = TextEditingController();
  final TextEditingController _priceallController = TextEditingController();
  final TextEditingController _priceallSellController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showrefresh() async {
    final data = await DatabaseHelper.getItems();
    final mydata = await DatabaseHelper_Sell.getItems();
    setState(() {
      myDataSell = mydata;
      myData = data;
      final existingData =myData.firstWhere((element) => element['id'] == widget.id);
      titleController.text = existingData['title'];
      title.text = existingData['title'];
      descriptionController.text = existingData['description'];
      categoriesController.text = existingData['categories'];
      amountController.text = existingData['amount'];
      sizeController.text = existingData['size'];
      priceoneController.text = moneyFormat(existingData['priceone']);
      priceallController.text = moneyFormat(existingData['priceall']);
    });

  }



  Widget edittextthis(TextEditingController controller, String title){
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('${title} ', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),  ),
          Expanded(
          child:
          IntrinsicWidth(
              child: TextFormField(
                textAlign: TextAlign.start,
                minLines: 1,
                maxLines: 2,
                controller: controller,
                enabled: false,
                style: TextStyle(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.grey, ) ),
              ),
            )
          )
        ],
      )
    );
  }

  String toDouble(String value){
    var k1 = value.replaceAll(',', '');
    return k1.toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => Homepage_(store: widget.store, icon: widget.icon),));
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          IntrinsicWidth(
          child: TextFormField(controller: title,
          enabled: false,
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey, ) ),),),
        IconButton(onPressed: (){
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (BuildContext context) => Sell(icon:  widget.icon, store: widget.store)));
    }, icon: myDataSell.isEmpty ? Icon(Icons.shopping_bag_rounded, color: Colors.black,): Icon(Icons.shopping_bag_rounded, color: Colors.green,))
          ],
        ),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              width: 130,
              height: 130,
              child: image(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.green)
              ),
                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                child:Container(
                margin: EdgeInsets.all(10),
                child:Column(
                  children: [
                    edittextthis(titleController, 'Nama Barang  :'),
                    edittextthis(descriptionController, 'Deskripsi Barang :'),
                    edittextthis(categoriesController, 'Kategori Barang :'),
                    Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Jumlah Barang : ', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),  ),
                            IntrinsicWidth(
                              child: TextFormField(
                                controller: amountController,
                                enabled: false,
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.grey, ) ),
                              ),
                            ),
                            IntrinsicWidth(
                              child: TextFormField(
                                controller: sizeController,
                                enabled: false,
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.grey, ) ),
                              ),
                            ),
                          ],
                        )
                    ),
                    edittextthis(priceoneController, 'Harga Perbarang : Rp.'),
                    edittextthis(priceallController, 'Harga Semua Barang  : Rp.'),
                  ],
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.green)
                ),
              child: Container(
                //margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit,color: Colors.white,size: 28,),
                        onPressed: () {
                          showMyForm(widget.id);
                        }
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete,color: Colors.white, size: 28),
                        onPressed: () {
                          showDeleteDialog(context, widget.id);
                        }
                    ),
                    IconButton(
                        onPressed: (){
                          addSell(widget.id, titleController.text, descriptionController.text, categoriesController.text, toDouble(priceallController.text), toDouble(priceoneController.text), amountController.text, sizeController.text);
                        },
                        icon:  Icon(
                          Icons.sell,
                          size: 28,
                          color: Colors.white,
                        ),),
                  ],
                ),
              )
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

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
                        double result = double.parse(maxthis) - max;
                        double totalresult = double.parse(priceall)- double.parse(toDouble(_priceallSellController.text));
                        await DatabaseHelper.updateItem(id, title, description, categories, maxthis, selectedValue, priceone, priceall);
                        await DatabaseHelper_Sell.createItem(widget.id, title, description, categories, max.toString(), selectedValue, priceone, toDouble(_priceallSellController.text));
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(max.toString()+selectedValue.toString())));
                          Navigator.of(context).pop();
                        });
                        showrefresh();
                      }, child: Text("Taruh Dilaman Jual", style: TextStyle(color: Colors.blueGrey),),
                    ),
                  )
                ],
              ));
        },);
    });
  }

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
                    showrefresh();
                  },
                  child: Text(id == null ? 'Buat Baru' : 'Perbarui', style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ));
  }

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
    showrefresh();
  }

  String moneyFormat(String value) {
    String k = value+"0";
    var k1 = k.replaceAll('.', '');
    double k2 = double.parse(k1);
    final formatter = new NumberFormat.simpleCurrency(name: "",decimalDigits: 2);
    String newText = formatter.format(k2/100);
    return newText;
  }
}
