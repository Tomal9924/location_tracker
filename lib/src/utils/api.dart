class Api {
  static String _baseUrl = "https://jm-api.rmrcloud.com";
  static String get token => "$_baseUrl/token";

  static String get saveData => "$_baseUrl/api/SaveFloatingPoint";
  static String get userInfo => "$_baseUrl/api/GetUserByUserName";
  static String get floatingPoints => "$_baseUrl/api/GetFloatingPointByUserId";
  static String get floatingPointsDetails => "$_baseUrl/api/GetFloatingPointById";
  static String fileUrl(String path) => "$_baseUrl$path";
}
