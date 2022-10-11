part "production_config.dart";

abstract class Config {
  String get mumbleServer => "127.0.0.1";
  String get personManagementServer => "http://dss.aegean.gr:8090/";
  String get authenticationServer => "http://localhost:8080";
  String get clientSecret => "";
  Map<String, dynamic> get authHeaders => {
    "Cookie": "mongo-express=s%253AyJ65f8rsA2Bst16YqIaupbF_82BYcfSm.4ykp0vdwOUaFhu%252BnEb3TH5lGr8gnzt2T5t1PUltMBek",
  };
  Map<String, String> get authCookies => {};
}
