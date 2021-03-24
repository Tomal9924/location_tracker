import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:location_tracker/src/utils/constants.dart';

part 'floating_point.g.dart';

@HiveType(adapterName: "FloatingPointAdapter", typeId: tableFloatingPoint)
class FloatingPoint {
  @HiveField(0)
  int id;
  @HiveField(1)
  String district;
  @HiveField(2)
  String city;
  @HiveField(3)
  String routeName;
  @HiveField(4)
  double lat;
  @HiveField(5)
  double lng;
  @HiveField(6)
  String isDealer;
  @HiveField(7)
  String routeDay;
  @HiveField(8)
  String shopName;
  @HiveField(9)
  String ownerName;
  @HiveField(10)
  String ownerPhone;
  @HiveField(11)
  String monthlySaleTv;
  @HiveField(12)
  String monthlySaleRf;
  @HiveField(13)
  String monthlySaleAc;
  @HiveField(14)
  String showroomSize;
  @HiveField(15)
  String files;
  @HiveField(16)
  String shopSubType;
  @HiveField(17)
  String registeredName;
  @HiveField(18)
  String competitorList;
  @HiveField(19)
  String thana;
  @HiveField(20)
  String comment;
  @HiveField(21)
  String zone;
  @HiveField(22)
  String area;
  @HiveField(23)
  String point;
  @HiveField(24)
  String division;

  FloatingPoint({
    @required this.id,
    @required this.district,
    @required this.city,
    @required this.routeName,
    @required this.lat,
    @required this.lng,
    @required this.isDealer,
    @required this.routeDay,
    @required this.shopName,
    @required this.ownerName,
    @required this.ownerPhone,
    @required this.monthlySaleTv,
    @required this.monthlySaleRf,
    @required this.monthlySaleAc,
    @required this.showroomSize,
    @required this.files,
    @required this.shopSubType,
    this.registeredName,
    @required this.competitorList,
    @required this.thana,
    @required this.comment,
    @required this.zone,
    @required this.area,
    @required this.point,
    @required this.division,
  });
}
