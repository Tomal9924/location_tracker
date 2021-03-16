class Api {
  static String _baseUrl = "http://jme-api.rmrcloud.com";
  static String get token => "$_baseUrl/token";

  static String get saveData => "$_baseUrl/api/SaveFloatingPoint";
  static String get userInfo => "$_baseUrl/api/GetUserByUserName";
  static String get floatingPoints => "$_baseUrl/api/GetFloatingPointByUserId";
  static String get floatingPointsDetails => "$_baseUrl/api/GetFloatingPointById";
  static String fileUrl(String path) => "$_baseUrl$path";

  static String get lookUpDistrict => "District";
  static String get lookUpThana => "Thana";
  static String get lookUp => "$_baseUrl/api/GetLookupbyKey";
  static String get getCompetitors => "$_baseUrl/api/GetCompetitorList";
}
