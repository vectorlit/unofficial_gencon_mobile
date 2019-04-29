import 'dart:async';

import 'package:unofficial_gencon_mobile/database.dart';
import 'package:unofficial_gencon_mobile/models/eventmodel.dart';
import 'package:unofficial_gencon_mobile/app_state_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Network {
  static const String eventBaseURL = "https://unofficialgen.co/GenConEvents";
  static const String userEventListBaseURL = "https://unofficialgen.co";
  static const String globalOptionsBaseURL = "https://unofficialgen.co/GenConMobile";
  static const int restDefaultPagingAmount = 250;
  static const int restConnectionAttemptRetryCount = 3;

  static var restFormatter = DateFormat("yyyy-MM-dd't'HH:mm:ss");

  // static void getAllEventsAfterDateRunner(DateTime date) async {
  //   Stream<EventListChunkModel> eventStream = getEventsAfterDate(date);
  //   StreamController<EventListChunkModel> sc = StreamController();
  //   sc.addStream(eventStream);



  //   sc.close();
  // }

  static String eventAllEventsAfterDateURL(DateTime date, {int take = restDefaultPagingAmount, int skip = 0, bool countOnly = false}) {
    var formattedDate = restFormatter.format(date);
    if (countOnly) {
      return "$eventBaseURL/timedelay/$formattedDate/numResults";
    }
    else {
      return "$eventBaseURL/timedelay/$formattedDate/$take/$skip";
    }
  }
 
  static Stream<EventCommitInfoModel> getEventsAfterDate(DateTime date) async* {
    int maxCount = await getEventCountAfterDate(date);
    int count = 0;
    int retryCount = restConnectionAttemptRetryCount;
    String json;
    ConventionDatabase db;
    List<EventModel> currentEvents = [];
    while (count < maxCount && retryCount > 0) {
      try {
        json = await http.read(eventAllEventsAfterDateURL(date, skip: count));
        // currentEvents = await compute(eventModelListFromJson, json);
        currentEvents = await EventModel.fromJsonArray(json);
        count += currentEvents.length;
        print("count: $count ");
        db = await AppStateModel.database;
        await db.upsertEventModels(currentEvents);
        yield new EventCommitInfoModel(maxCount, currentEvents.length);
      }
      catch (ex) {
        retryCount--;
        var db = await AppStateModel.database;
        db.log("Encountered a network error: \"$ex\". $retryCount attempts left (${retryCount > 0 ? "retrying..." : "giving up"})");
      }
    }

    print("stream is closing.");
  }

  static Future<int> getEventCountAfterDate(DateTime date) async {
    int returnMe = -1;

    try {
      returnMe = int.parse(await http.read(eventAllEventsAfterDateURL(date, countOnly: true)));
    } catch (ex) {

    }

    return returnMe;
  }

  // static Future<List<EventModel>> getEventsAfterDate(DateTime date) async {
  //   List<EventModel> returnMe = [];

  //   try {
  //     String json = await http.read(eventAllEventsAfterDateURL(date: date));
  //     returnMe = EventModel.fromJsonArray(json);
  //   } catch (ex) {
  //     print(ex.toString());
  //   }

  //   return returnMe;
  // }
}

class EventListChunkModel {
  final int maxNumberOfEvents;
  final List<EventModel> events;
  const EventListChunkModel(this.maxNumberOfEvents, this.events);
}

class EventCommitInfoModel {
  final int maxNumberOfEvents;
  final int currentNumberOfEvents;
  const EventCommitInfoModel (this.maxNumberOfEvents, this.currentNumberOfEvents);
}
