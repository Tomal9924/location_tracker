class FloatingPoint {
  int id;
  String guid;
  String shopName;
  String ownerName;
  String ownerPhone;
  String city;
  String district;
  bool isDealer;
  double lat;
  double lng;

  FloatingPoint({this.id, this.guid, this.shopName, this.ownerName, this.ownerPhone, this.lat, this.lng});

  FloatingPoint.fromJSON(Map<String, dynamic> map) {
    id = map["Id"];
    guid = map["FloatingPointId"];
    shopName = map["ShopName"];
    ownerName = map["OwnerName"];
    ownerPhone = map["OwnerPhone"];
    city = map["City"];
    district = map["District"];
    isDealer = map["IsDealer"]?? false;
    try {
      lat = double.parse(map["Lat"]) ?? 0;
      lng = double.parse(map["Lng"]) ?? 0;
    } catch (error) {
      lat = 0;
      lng = 0;
    }
  }
}