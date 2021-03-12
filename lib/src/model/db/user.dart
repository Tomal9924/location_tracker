import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:location_tracker/src/utils/helper.dart';

part 'user.g.dart';

@HiveType(adapterName: "UserAdapter", typeId: tableUser)
class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  String guid;
  @HiveField(2)
  String name;
  @HiveField(3)
  String email;
  @HiveField(4)
  String username;
  @HiveField(5)
  String phone;
  @HiveField(6)
  String street;
  @HiveField(7)
  String city;
  @HiveField(8)
  String state;
  @HiveField(9)
  String zip;
  @HiveField(10)
  String profilePicture;
  @HiveField(11)
  String lastLoggedIn;
  @HiveField(12)
  String companyGUID;
  @HiveField(13)
  String companyName;
  @HiveField(14)
  String companyWebsite;
  @HiveField(15)
  String companyLogo;
  @HiveField(16)
  bool isActive;
  @HiveField(17)
  bool isDeleted;
  @HiveField(18)
  bool isAuthenticated;
  @HiveField(19)
  String token;
  @HiveField(20)
  String password;
  @HiveField(21)
  int expiresOn;

  User(
      {this.id,
      this.guid,
      this.name,
      this.email,
      this.username,
      this.phone,
      this.street,
      this.city,
      this.state,
      this.zip,
      this.profilePicture,
      this.lastLoggedIn,
      this.companyGUID,
      this.companyName,
      this.companyWebsite,
      this.companyLogo,
      this.isActive,
      this.isDeleted,
      this.isAuthenticated,
      this.token,
      this.password,
      this.expiresOn});

  User.fromAuth(Map<String, dynamic> result, User old) {
    id = result["emp"]["Id"];
    guid = result["emp"]["UserId"];
    name = Helper.beautifyName(result["emp"]["Title"],
        result["emp"]["FirstName"], result["emp"]["LastName"]);
    phone = result["emp"]["Phone"];
    email = result["emp"]["Email"];
    username = result["emp"]["UserName"];
    street = result["emp"]["Street"];
    city = result["emp"]["City"];
    state = result["emp"]["State"];
    zip = result["emp"]["ZipCode"];
    profilePicture = result["emp"]["ProfilePicture"];
    isActive = result["emp"]["IsActive"] ?? false;
    isDeleted = result["emp"]["IsDeleted"] ?? false;
    companyGUID = result["company"]["CompanyId"];
    companyName = result["company"]["CompanyName"];
    companyWebsite = result["company"]["Website"];
    companyLogo = result["company"]["CompanyLogo"];
    lastLoggedIn = DateFormat("MM/dd/yyyy 'at' hh:mm a").format(DateTime.now());
    isAuthenticated = true;
    token = old.token;
    password = old.password;
    expiresOn = old.expiresOn;
  }
}
