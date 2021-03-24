class Api {
  static String _baseUrl = "https://jme-api.made-in-bd.net/v1";
  static String get token => "$_baseUrl/token";

  static String get saveData => "$_baseUrl/save-shop";
  static String get userInfo => "$_baseUrl/get-user-by-name";
  static String get locationPoints => "$_baseUrl/get-shops-lite";
  static String get locationPointsDetails => "$_baseUrl/get-shop-detail";
  static String fileUrl(String path) => "$_baseUrl$path";

  static String get lookUpDistrict => "District";
  static String get lookUpThana => "Thana";
  static String get lookUp => "$_baseUrl/get-lookup-by-datakey";
  static String get lookUpKeys => "District,Thana,Zone,Area,Dealer";
  static String get getCompetitors => "$_baseUrl/get-competitors";
}
