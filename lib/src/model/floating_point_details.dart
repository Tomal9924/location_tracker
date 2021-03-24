import 'package:intl/intl.dart';

class FloatingPointDetails {
  int id;
  String locationPointGuid;
  String zone;
  String area;
  String pointName;
  String routeName;
  String routeDay;
  String district;
  String thana;
  String cityVillage;
  double lat;
  double lng;
  String locationType;
  String shopType;
  String registeredName;
  String shopName;
  String ownerName;
  String ownerPhone;
  bool isDealer;
  List<String> files = [];
  String saleTV;
  String saleRF;
  String saleAC;
  String showroomSize;
  String comments;
  String createdDate;

  FloatingPointDetails(
      {this.id,
      this.locationPointGuid,
      this.zone,
      this.area,
      this.pointName,
      this.routeName,
      this.routeDay,
      this.district,
      this.thana,
      this.cityVillage,
      this.lat,
      this.lng,
      this.locationType,
      this.shopType,
      this.registeredName,
      this.shopName,
      this.ownerName,
      this.ownerPhone,
      this.isDealer,
      this.files,
      this.saleTV,
      this.saleRF,
      this.saleAC,
      this.showroomSize,
      this.comments});

  FloatingPointDetails.fromJSON(Map<String, dynamic> map) {
    DateTime dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
        .parse(map["LocationInfo"][0]["CreatedDate"].contains(".") ? map["LocationInfo"][0]["CreatedDate"] : "${map["LocationInfo"][0]["CreatedDate"]}.000")
        .add(DateTime.now().timeZoneOffset);
    id = map["LocationInfo"][0]["Id"];
    locationPointGuid = map["LocationInfo"][0]["LocationPointId"];
    zone = map["LocationInfo"][0]["Zone"];
    area = map["LocationInfo"][0]["Area"];
    pointName = map["LocationInfo"][0]["PointName"];
    routeName = map["LocationInfo"][0]["RouteName"];
    routeDay = map["LocationInfo"][0]["RouteDay"];
    thana = map["LocationInfo"][0]["Thana"];
    district = map["LocationInfo"][0]["District"];
    cityVillage = map["LocationInfo"][0]["CityVillage"];
    shopName = map["LocationInfo"][0]["ShopName"];
    ownerName = map["LocationInfo"][0]["OwnerName"];
    ownerPhone = map["LocationInfo"][0]["OwnerPhone"];
    locationType = map["LocationInfo"][0]["LocationType"];
    shopType = map["LocationInfo"][0]["ShopType"];
    registeredName = map["LocationInfo"][0]["RegisteredName"];
    map["LocationImage"].forEach((image) {
      files.add(image["ImageLocation"]);
    });
    try {
      lat = double.parse(map["LocationInfo"][0]["Lat"]) ?? 0;
      lng = double.parse(map["LocationInfo"][0]["Lng"]) ?? 0;
      createdDate = DateFormat("hh:mma MM/dd/yyyy").format(dateTime);
    } catch (error) {
      lat = 0;
      lng = 0;
    }
    saleTV = map["LocationInfo"][0]["MonthlySaleTv"].toString();
    saleRF = map["LocationInfo"][0]["MonthlySaleRf"].toString();
    saleAC = map["LocationInfo"][0]["MonthlySaleAc"].toString();
    showroomSize = map["LocationInfo"][0]["ShowroomSize"].toString();
  }
}
