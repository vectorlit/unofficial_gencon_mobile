import 'package:unofficial_gencon_mobile/models/eventmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ConventionDatabase {
  //TODO: Move all of these static variables to a global class and pull them from defaults, and then the database
  String dbLoc;
  String dbFileName = "GenconMobile5SQLite.db3";
  static DateTime defaultStartDateTime = DateTime.parse('2018-01-01');
  static Database _db;
  
  ConventionDatabase._();
  static final ConventionDatabase db = ConventionDatabase._();

  Future<DateTime> get awaitCurrentStartDateTime async {
    //TODO: This doesn't account for interrupted downloads. Figure out a way to fix it.
    var db = await awaitDB;

    var query = "SELECT syncTime FROM ${EventModel.tableName} ORDER BY syncTime DESC LIMIT 1";

    var returnMe = QueryHelpers.firstDateTimeValue(await db.rawQuery(query));

    return returnMe == null ? defaultStartDateTime : returnMe;
  }

  Future<Database> get awaitDB async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future<ConventionDatabase> create() async {
    var conventionDatabase = ConventionDatabase._();
    await conventionDatabase.initDb();
    return conventionDatabase;
  }

  Future initDb() async {
    print("Database init triggered.");

    dbLoc = join((await getApplicationDocumentsDirectory()).path, dbFileName);

    // await deleteDatabase(dbLoc);

    var createStatements = [
      // GenEvent
      EventModel.createStatement,

      // UserEventList
      'CREATE TABLE "UserEventList" ( "ID" integer primary key autoincrement not null , "ExternalAddress" varchar , "InternalSecret" varchar , "Title" varchar collate NOCASE , "eventsBlobbed" varchar , "HasEventListChangedSinceSync" integer )',

      // GlobalOption
      'CREATE TABLE "GlobalOption" ( "ID" varchar primary key not null , "type" varchar , "data_string" varchar , "data_long" integer , "data_bool" integer , "data_int" integer )',

      // GenEventUserEventList
      'CREATE TABLE "GenEventUserEventList" ( "UserEventListID" integer , "GenEventID" varchar )',

      // EventChangeLog
      'CREATE TABLE "EventChangeLog" ( "ID" integer primary key autoincrement not null , "GenEventID" varchar , "Property" varchar , "NewValue" varchar , "OldValue" varchar , "ChangeTime" bigint )',

      // DebugLog
      'CREATE TABLE "DebugLog" ("time" bigint, "logText" varchar)',

      // GenEventUserEventList_GenEventID Index
      'CREATE INDEX "' +
          EventModel.tableName +
          'UserEventList_' +
          EventModel.tableName +
          'ID" on "' +
          EventModel.tableName +
          'UserEventList"("' +
          EventModel.tableName +
          'ID")',

      // GenEventUserEventList_UserEventListID Index
      'CREATE INDEX "' +
          EventModel.tableName +
          'UserEventList_UserEventListID" on "' +
          EventModel.tableName +
          'UserEventList"("UserEventListID")',

      'CREATE INDEX "GenEvent_content_startDateTime" on "GenEvent_content"("c14startDateTime")',
    ];


    List<QueryHolder> insertTestStatements = [];


    var db = await openDatabase(dbLoc, version: 100,
        onCreate: (Database db, int version) async {
      for (int i = 0; i < createStatements.length; i++) {
        await db.execute(createStatements[i]);
      }

      for (int i = 0; i < insertTestStatements.length; i++) {
        await db.execute(
          insertTestStatements[i].query, insertTestStatements[i].arguments);
      }
    });

    return db;
  }

  Future upsertEventModels(List<EventModel> eventModels) async {
    List<QueryHolder> upsertStatements = [];

    eventModels.forEach((f) => {upsertStatements.add(f.getInsertQuery)});

    var db = await awaitDB;

    await db.transaction((txn) async {
      Batch batch = txn.batch();
      for (int i = 0; i < upsertStatements.length; i++) {
        batch.rawInsert(upsertStatements[i].query, upsertStatements[i].arguments);
      }

      // await batch.commit(noResult: true, continueOnError: true);
      await batch.commit();
    });

    
  }

  Future<int> getEventCount() async {
    var db = await awaitDB;
    var resultList = await db.rawQuery('SELECT COUNT(*) FROM GenEvent');
    return QueryHelpers.firstIntValue(resultList);
  }

  Future<EventModel> getEventModel(int index) async {
    var db = await awaitDB;
    List<Map> resultList = await db.rawQuery('SELECT * FROM GenEvent ORDER BY startDateTime ASC LIMIT 1 OFFSET $index');
    return QueryHelpers.firstEventModelValue(resultList);
  }
  
    Future<List<EventModel>> getEventModels(int limit) async {
    var db = await awaitDB;
    List<Map> resultList = await db.rawQuery('SELECT * FROM GenEvent ORDER BY startDateTime ASC LIMIT $limit');
    List<EventModel> eventModels = new List();
    for (int i = 0; i < resultList.length; i++) {
      eventModels.add(EventModel.fromInternalMap(resultList[i]));
    }
    return eventModels;
  }

  Future<List<EventModel>> getAllEventModels() async {
    var db = await awaitDB;
    List<Map> resultList = await db.rawQuery('SELECT * FROM GenEvent ORDER BY startDateTime ASC'); 
    List<EventModel> eventModels = new List();
    for (int i = 0; i < resultList.length; i++) {
      // var eventModel = new EventModel(
      //     description: resultList[i]["Description"],
      //     title: resultList[i]["Title"]);
      eventModels.add(EventModel.fromInternalMap(resultList[i]));
    }
    return eventModels;
  }

  Future log(String logText) async {
    var db = await awaitDB;
    await db.transaction((txn) async {
      await txn.rawInsert('INSERT INTO DebugLog VALUES (?, ?)', [DateTime.now().millisecondsSinceEpoch, logText]);
    });
  }

}

class QueryHolder {
  String query;
  List<dynamic> arguments = new List<dynamic>();

  QueryHolder(this.query, this.arguments);
}

class QueryHelpers {
  static DateTime firstDateTimeValue(List<Map<String, dynamic>> list) {
    if (list != null && list.isNotEmpty) {
      final Map<String, dynamic> firstRow = list.first;
      if (firstRow.isNotEmpty) {
        return DateTime.fromMillisecondsSinceEpoch(firstRow.values?.first);
      }
    }
    return null;
  }
  
  static int firstIntValue(List<Map<String, dynamic>> list) {
    if (list != null && list.isNotEmpty) {
      final Map<String, dynamic> firstRow = list.first;
      if (firstRow.isNotEmpty) {
        return parseInt(firstRow.values?.first); 
      }
    }
    return null;
  }

  static EventModel firstEventModelValue(List<Map<String, dynamic>> list) {
    if (list != null && list.isNotEmpty) {
      final Map<String, dynamic> firstRow = list.first;
      if (firstRow.isNotEmpty) {
        return EventModel.fromInternalMap(firstRow);
      }
    }
    return null;
  }

  static int parseInt(Object object) {
    if (object is int) {
      return object;
    } else if (object is String) {
      try {
        return int.parse(object);
      } catch (_) {}
    }
    return null;
  }
}

class QueryOptions {
  QueryOptions();
}