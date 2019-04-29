import 'package:unofficial_gencon_mobile/database.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timezone/timezone.dart';

class AppStateModel extends Model {
  static Future<ConventionDatabase> get database async {
    while (lock) {
      await Future.delayed(const Duration(milliseconds: 5));
    }

    if (_db != null) {
      return _db;
    }
    lock = true;
    var tzBinData = await loadDefaultData();
    initializeDatabase(tzBinData);
    indyLoc = getLocation('America/Indiana/Indianapolis');
    _db = await ConventionDatabase.create();
    lock = false;
    return _db;
  }

  static Future<List<int>> loadDefaultData() async {
    var byteData = await rootBundle.load('bindata/2018i.tzf');
    return byteData.buffer.asUint8List();
  }

  static bool lock = false;

  static ConventionDatabase _db;

  static Location indyLoc;

  AppStateModel();
}
