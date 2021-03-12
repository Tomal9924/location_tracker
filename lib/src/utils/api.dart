class Api {
  static String _baseUrl = "http://jm-api.rmrcloud.com";
  static String get token => "$_baseUrl/token";

  static String get saveData => "$_baseUrl/api/SaveFloatingPoint";
  static String get userInfo => "$_baseUrl/api/GetUserByUserName";
  static String get floatingPoints => "$_baseUrl/api/GetFloatingPointByUserId";
}
