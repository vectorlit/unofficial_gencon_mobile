
// This is a static class of global lookups and other info.
// This data is mostly able to be overridden by downloaded data from the web service,
//  allowing the application to be updated via metadata without a hard app publish in many cases.
// As of now this is mostly unimplemented. Please see the Xamarin version of the app in order to see a good implementation example.

class Globals {
  Globals();

  static T getOption<T>(String title, dynamic defaultVal) {
    var option = cachedObjects[title];
    if (option != null) {
      return option as T;
    }
    return defaultVal as T;
  }

  static void setOption(String title, dynamic value, {bool commitToDatabase = true}) {

  }

  static Map cachedObjects = Map();

  static int get networkFailureRetryCount {
    return getOption<int>("networkFailureRetryCount", 3);
  }

  static set networkFailureRetryCount (int value) {

  }
}