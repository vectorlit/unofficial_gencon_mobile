import 'dart:convert';
import 'package:unofficial_gencon_mobile/database.dart';

class EventModel {

  static const String tableName = "GenEvent";

  static const String insertStatement = "INSERT INTO " +
      tableName +
      " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

  static const String createStatement = 'CREATE VIRTUAL TABLE "' +
      EventModel.tableName +
      '" using fts4 ( "id" varchar primary key not null collate NOCASE , "groupCompany" varchar , "title" varchar collate NOCASE , "description" varchar collate NOCASE , "longDescription" varchar collate NOCASE , "eventType" varchar , "rulesEdition" varchar , "gameSystem" varchar , "minimumPlayers" varchar , "maximumPlayers" varchar , "minimumAge" varchar , "experienceRequired" varchar , "materialsProvided" varchar , "isMaterialsProvided" integer , "startDateTime" bigint , "duration" varchar , "endDateTime" bigint , "location" varchar , "gMs" varchar , "webAddressMoreInfo" varchar , "emailAddressMoreInfo" varchar , "tournament" varchar , "isTournament" integer , "prerequisite" varchar , "availableTickets" integer , "ticketsSyncTime" bigint , "hasUpdateNotifications" integer , "cost" varchar , "parsedCost" float , "liveURL" varchar , "syncTime" bigint )';

  QueryHolder get getInsertQuery {
    return QueryHolder(insertStatement, [
      this.id,
      this.groupCompany,
      this.title,
      this.description,
      this.longDescription,
      this.eventType,
      this.rulesEdition,
      this.gameSystem,
      this.minimumPlayers,
      this.maximumPlayers,
      this.minimumAge,
      this.experienceRequired,
      this.materialsProvided,
      this.isMaterialsProvided,
      this.startDateTime.millisecondsSinceEpoch,
      this.duration,
      this.endDateTime.millisecondsSinceEpoch,
      this.location,
      this.gms,
      this.webAddressMoreInfo,
      this.emailAddressMoreInfo,
      this.tournament,
      this.isTournament,
      this.prerequisite,
      this.availableTickets,
      this.ticketsSyncTime.millisecondsSinceEpoch,
      this.hasUpdateNotifications,
      this.cost,
      this.parsedCost,
      this.liveURL,
      this.syncTime.millisecondsSinceEpoch
    ]);
  }

  EventModel(
      {this.id,
      this.groupCompany,
      this.title,
      this.description,
      this.longDescription,
      this.eventType,
      this.rulesEdition,
      this.gameSystem,
      this.minimumPlayers,
      this.maximumPlayers,
      this.minimumAge,
      this.experienceRequired,
      this.materialsProvided,
      this.isMaterialsProvided,
      this.startDateTime,
      this.duration,
      this.endDateTime,
      this.location,
      this.gms,
      this.webAddressMoreInfo,
      this.emailAddressMoreInfo,
      this.tournament,
      this.isTournament,
      this.prerequisite,
      this.availableTickets,
      this.ticketsSyncTime,
      this.hasUpdateNotifications,
      this.cost,
      this.parsedCost,
      this.liveURL,
      this.syncTime});

  String id;
  String groupCompany;
  String title;
  String description;
  String longDescription;
  String eventType;
  String rulesEdition;
  String gameSystem;
  String minimumPlayers;
  String maximumPlayers;
  String minimumAge;
  String experienceRequired;
  String materialsProvided;
  bool isMaterialsProvided;
  DateTime startDateTime;
  String duration;
  DateTime endDateTime;
  String location;
  String gms;
  String webAddressMoreInfo;
  String emailAddressMoreInfo;
  String tournament;
  bool isTournament;
  String prerequisite;
  int availableTickets;
  DateTime ticketsSyncTime;
  bool hasUpdateNotifications;
  String cost;
  double parsedCost;
  String liveURL;
  DateTime syncTime;

  // TZDateTime get localStartDateTime {
  //   return TZDateTime.from(startDateTime, AppStateModel.indyLoc);
  // }

  static Future<List<EventModel>> fromJsonArray(jsonArray) async {
    List<EventModel> returnMe = [];

    try {
      List<dynamic> array = jsonDecode(jsonArray);
      returnMe = array
          .map((dynamic model) => EventModel.fromExternalMap(model))
          .toList();
    } catch (ex) {
      print(ex.toString());
    }

    return returnMe;
  }

  EventModel.fromInternalMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.groupCompany = map['groupCompany'];
    this.title = map['title'];
    this.description = map['description'];
    this.longDescription = map['longDescription'];
    this.eventType = map['eventType'];
    this.rulesEdition = map['rulesEdition'];
    this.gameSystem = map['gameSystem'];
    this.minimumPlayers = map['minimumPlayers'];
    this.maximumPlayers = map['maximumPlayers'];
    this.minimumAge = map['minimumAge'];
    this.experienceRequired = map['experienceRequired'];
    this.materialsProvided = map['materialsProvided'];
    this.isMaterialsProvided = map['isMaterialsProvided'] == "1" ? true : false;
    this.startDateTime =
        DateTime.fromMillisecondsSinceEpoch(map['startDateTime']);
    this.duration = map['duration'];
    this.endDateTime = DateTime.fromMillisecondsSinceEpoch(map['endDateTime']);
    this.location = map['location'];
    this.gms = map['gMs'];
    this.webAddressMoreInfo = map['webAddressMoreInfo'];
    this.emailAddressMoreInfo = map['emailAddressMoreInfo'];
    this.tournament = map['tournament'];
    this.isTournament = map['isTournament'] == "1" ? true : false;
    this.prerequisite = map['prerequisite'];
    this.availableTickets = map['availableTickets'];
    this.ticketsSyncTime =
        DateTime.fromMillisecondsSinceEpoch(map['ticketsSyncTime']);
    this.hasUpdateNotifications = map['hasUpdateNotifications'];
    this.cost = map['cost'];
    this.parsedCost = map['parsedCost'];
    this.liveURL = map['liveURL'];
    this.syncTime = DateTime.fromMillisecondsSinceEpoch(map['syncTime']);
  }

  EventModel.fromExternalMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.groupCompany = map['groupCompany'];
    this.title = map['title'];
    this.description = map['description'];
    this.longDescription = map['longDescription'];
    this.eventType = map['eventType'];
    this.rulesEdition = map['rulesEdition'];
    this.gameSystem = map['gameSystem'];
    this.minimumPlayers = map['minimumPlayers'];
    this.maximumPlayers = map['maximumPlayers'];
    this.minimumAge = map['minimumAge'];
    this.experienceRequired = map['experienceRequired'];
    this.materialsProvided = map['materialsProvided'];
    this.isMaterialsProvided = map['isMaterialsProvided'] == "1" ? true : false;
    this.startDateTime = DateTime.parse(map['startDateTime']);
    this.duration = map['duration'];
    this.endDateTime = DateTime.parse(map['endDateTime']);
    this.location = map['location'];
    this.gms = map['gMs'];
    this.webAddressMoreInfo = map['webAddressMoreInfo'];
    this.emailAddressMoreInfo = map['emailAddressMoreInfo'];
    this.tournament = map['tournament'];
    this.isTournament = map['isTournament'] == "1" ? true : false;
    this.prerequisite = map['prerequisite'];
    this.availableTickets = map['availableTickets'];
    this.ticketsSyncTime = DateTime.parse(map['ticketsSyncTime']);
    this.hasUpdateNotifications = map['hasUpdateNotifications'];
    this.cost = map['cost'];
    this.parsedCost = map['parsedCost'];
    this.liveURL = map['liveURL'];
    this.syncTime = DateTime.parse(map['syncTime']);
  }

  EventModel.fromJson(String json) : this.fromExternalMap(jsonDecode(json));
}