import 'package:intl/intl.dart';

class FloatingPoint {
  int id;
  String guid;
  String shopName;
  String ownerName;
  String ownerPhone;
  String thana;
  String district;
  bool isDealer;
  double lat;
  double lng;
  String createdDate;

  FloatingPoint({this.id, this.guid, this.shopName, this.ownerName, this.ownerPhone, this.lat, this.lng, this.createdDate});

  FloatingPoint.fromJSON(Map<String, dynamic> map) {
    DateTime dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
        .parse(map["CreatedDate"].contains(".") ? map["CreatedDate"] : "${map["CreatedDate"]}.000")
        .add(DateTime.now().timeZoneOffset);
    id = map["Id"];
    guid = map["LocationPointId"];
    shopName = map["ShopName"];
    ownerName = map["OwnerName"];
    ownerPhone = map["OwnerPhone"];
    thana = map["Thana"];
    district = map["District"];
    isDealer = map["LocationType"] == "Dealer" ?? false;
    try {
      lat = double.parse(map["Lat"]) ?? 0;
      lng = double.parse(map["Lng"]) ?? 0;
      createdDate = DateFormat("hh:mma MM/dd/yyyy").format(dateTime);
    } catch (error) {
      lat = 0;
      lng = 0;
    }
  }
}
