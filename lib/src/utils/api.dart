class Api {
  static String _baseUrl = "https://jme-api.made-in-bd.net/v1";
  static String get token => "$_baseUrl/token";

  static String get saveData => "$_baseUrl/api/SaveLocationPoint";
  static String userInfo(String username) => "$_baseUrl/get-user-by-name?username=$username";
  static String get locationPoints => "$_baseUrl/api/GetLocationPointByUserId";
  static String get locationPointsDetails => "$_baseUrl/api/GetLocationPointById";
  static String fileUrl(String path) => "$_baseUrl$path";

  static String get lookUpDistrict => "District";
  static String get lookUpThana => "Thana";
  static String get lookUp => "$_baseUrl/api/GetLookupByKey";
  static String get lookUpKeys => "District,Thana,Zone,Area,Dealer";
  static String get getCompetitors => "$_baseUrl/api/GetCompetitorList";
}
