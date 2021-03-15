class FloatingPointDetails {
  int id;
  String guid;
  String routeName;
  String routeDay;
  String shopName;
  String ownerName;
  String ownerPhone;
  String city;
  String district;
  bool isDealer;
  double lat;
  double lng;
  List<String> files = [];
  String waltonTV;
  String waltonRF;
  String visionTV;
  String visionRF;
  String marcelTV;
  String ministerRF;
  String saleTV;
  String saleRF;
  String saleAC;
  String showroomSize;
  String displayIn;
  String displayOut;

  FloatingPointDetails({this.id, this.guid, this.shopName, this.ownerName, this.ownerPhone, this.lat, this.lng, this.files});

  FloatingPointDetails.fromJSON(Map<String, dynamic> map) {
    id = map["fpDetails"]["Id"];
    guid = map["fpDetails"]["FloatingPointId"];
    routeName = map["fpDetails"]["Name"];
    routeDay = map["fpDetails"]["RouteDay"];
    shopName = map["fpDetails"]["ShopName"];
    ownerName = map["fpDetails"]["OwnerName"];
    ownerPhone = map["fpDetails"]["OwnerPhone"];
    city = map["fpDetails"]["City"];
    district = map["fpDetails"]["District"];
    isDealer = map["fpDetails"]["IsDealer"] ?? false;
    map["fpImageList"].forEach((image) {
      files.add(image["ImageLocation"]);
    });
    try {
      lat = double.parse(map["fpDetails"]["Lat"]) ?? 0;
      lng = double.parse(map["fpDetails"]["Lng"]) ?? 0;
    } catch (error) {
      lat = 0;
      lng = 0;
    }
    waltonTV = map["fpDetails"]["Competitor1TvWalton"].toString();
    waltonRF = map["fpDetails"]["Competitor1RfWalton"].toString();
    visionTV = map["fpDetails"]["Competitor2TvVision"].toString();
    visionRF = map["fpDetails"]["Competitor2RfVision"].toString();
    marcelTV = map["fpDetails"]["Competitor3TvMarcel"].toString();
    ministerRF = map["fpDetails"]["Competitor3RfMinister"].toString();
    saleTV = map["fpDetails"]["MonthlySaleTv"].toString();
    saleRF = map["fpDetails"]["MonthlySaleRf"].toString();
    saleAC = map["fpDetails"]["MonthlySaleAc"].toString();
    showroomSize = map["fpDetails"]["ShowroomSize"].toString();
    displayIn = map["fpDetails"]["DisplayIn"].toString();
    displayOut = map["fpDetails"]["DisplayOut"].toString();
  }
}
