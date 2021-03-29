import 'package:hive/hive.dart';
import 'package:location_tracker/src/utils/constants.dart';

part 'user.g.dart';

@HiveType(adapterName: "UserAdapter", typeId: tableUser)
class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  String guid;
  @HiveField(3)
  String username;
  @HiveField(4)
  String password;
  @HiveField(5)
  String email;
  @HiveField(6)
  bool isActive;
  @HiveField(7)
  bool isDeleted;
  @HiveField(8)
  String lastUpdatedBy;
  @HiveField(9)
  String lastUpdatedDate;
  @HiveField(10)
  String companyId;
  @HiveField(11)
  int rowState;
  @HiveField(12)
  bool isAuthenticated;
  @HiveField(13)
  String token;
  @HiveField(14)
  String phone;

  User(
      {this.id,
      this.guid,
      this.username,
      this.password,
      this.email,
      this.isActive,
      this.isDeleted,
      this.lastUpdatedBy,
      this.lastUpdatedDate,
      this.companyId,
      this.rowState,
      this.isAuthenticated,
      this.token});

  User.fromAuth(Map<String, dynamic> result, User old) {
    id = result["Id"];
    guid = result["UserId"];
    username = result["UserName"];
    email = result["EmailAddress"];
    isActive = result["IsActive"] ?? false;
    isDeleted = result["IsDeleted"] ?? false;
    lastUpdatedBy = result["LastUpdatedBy"];
    lastUpdatedDate = result["LastUpdatedDate"];
    companyId = result["CompanyId"];
    rowState = result["RowState"];
    phone = old.phone;
    isAuthenticated = true;
    token = old.token;
    password = old.password;
  }
}
