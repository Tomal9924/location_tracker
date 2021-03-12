class FloatingPoint {
  int id;
  String guid;
  String shopName;
  String ownerName;
  String ownerPhone;
  double lat;
  double lng;

  FloatingPoint({this.id, this.guid, this.shopName, this.ownerName, this.ownerPhone, this.lat, this.lng});

  FloatingPoint.fromJSON(Map<String, dynamic> map) {
    id = map["Id"];
    guid = map["FloatingPointId"];
    shopName = map["ShopName"];
    ownerName = map["OwnerName"];
    ownerPhone = map["OwnerPhone"];
    lat = double.parse(map["Lat"]);
    lng = double.parse(map["Lng"]);
  }
}
