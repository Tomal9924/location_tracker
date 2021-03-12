class UserHistory {
  String customerGUID;
  String shopName;
  String userPhone;
  String userAddress;
  String shopLocation;

  UserHistory(this.customerGUID, this.shopName, this.userPhone,
      this.userAddress, this.shopLocation);

  UserHistory.fromJson(Map<String, dynamic> customer, String routeId) {
    try {
      customerGUID = customer["CustomerId"];
      shopName = customer["Name"];
      userPhone = customer["Name"];
      userAddress = customer["Name"];
      shopLocation = customer["Name"];
    } catch (error) {
      print(error);
    }
  }
}
