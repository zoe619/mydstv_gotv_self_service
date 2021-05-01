import 'dart:io';

import 'package:eedc/model/billing.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper
{

  //  make DatabaseHelper a singleton i.e can only have one instance of the class
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database _db;

  DatabaseHelper._instance();

  String billTable = 'billing';
  String colId = 'id';
  String colTitle = 'title';
  String colAccount = 'account';
  String colPrevious = 'previous';
  String colCurrent = 'current';
  String colMonth = 'month';
  String colYear = 'year';
  String colPicture = 'picture';


  //  getter to return database
  Future<Database> get db async
  {
    if(_db == null)
    {
      return await initDb();
    }
    return _db;
  }

  //  function to create database in users device
  Future<Database> initDb() async
  {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/eedc.db';
    final billListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return billListDb;
  }


  void _createDb(Database db, int version) async
  {
    await db.execute(
        'CREATE TABLE $billTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colAccount TEXT, $colPrevious TEXT,'
            '$colCurrent TEXT, $colMonth TEXT, $colYear, TEXT, $colPicture TEXT)'
    );



  }



  //  this returns all the rows in billTable as maps
  Future<List<Map<String, dynamic>>> getBillMapList() async{
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(billTable);
    return result;
  }


  //  convert the maps to bill object and returns a list of bills
  Future<List<Billing>> getBillList() async{
    final List<Map<String, dynamic>> billMapList = await getBillMapList();
    final List<Billing> billList = [];
    billMapList.forEach((billMap){
      billList.add(Billing.fromMap(billMap));

    });

    return billList;
  }


  //  function to store bill as map cos sqflite store data as maps
  Future<int> insertBill(Billing bill) async{
    Database db = await this.db;
    final int result = await db.insert(billTable, bill.toMap());
    return result;

  }

//   function to update crime
  Future<int> updateBill(Billing bill) async{
    Database db = await this.db;
    final int result = await db.update(billTable, bill.toMap(),
      where: '$colId = ?',
      whereArgs: [bill.id],
    );
    return result;
  }




  Future<File> _compressImage(String imageId, File image) async{

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$imageId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }

  Future<String> uploadImage(File imageFile) async{
    String imageId = Uuid().v4();
    File image = await _compressImage(imageId, imageFile);


    return image.uri.toString();
  }

}