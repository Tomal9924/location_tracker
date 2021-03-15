import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:location_tracker/src/utils/constants.dart';

part 'point.g.dart';

@HiveType(adapterName: "PointAdapter", typeId: tablePoint)
class Point {
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
  bool isDealer;
  @HiveField(7)
  String routeDay;
  @HiveField(8)
  String shopName;
  @HiveField(9)
  String ownerName;
  @HiveField(10)
  String ownerPhone;
  @HiveField(11)
  String competitor1TvWalton;
  @HiveField(12)
  String competitor1RfWalton;
  @HiveField(13)
  String competitor2TvVision;
  @HiveField(14)
  String competitor2RfVision;
  @HiveField(15)
  String competitor3TvMarcel;
  @HiveField(16)
  String competitor3RfMinister;
  @HiveField(17)
  String monthlySaleTv;
  @HiveField(18)
  String monthlySaleRf;
  @HiveField(19)
  String monthlySaleAc;
  @HiveField(20)
  String showroomSize;
  @HiveField(21)
  String displayOut;
  @HiveField(22)
  String displayIn;
  @HiveField(23)
  String files;

  Point({
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
    @required this.competitor1TvWalton,
    @required this.competitor1RfWalton,
    @required this.competitor2TvVision,
    @required this.competitor2RfVision,
    @required this.competitor3TvMarcel,
    @required this.competitor3RfMinister,
    @required this.monthlySaleTv,
    @required this.monthlySaleRf,
    @required this.monthlySaleAc,
    @required this.showroomSize,
    @required this.displayOut,
    @required this.displayIn,
    @required this.files,
  });
}
