// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointAdapter extends TypeAdapter<Point> {
  @override
  final int typeId = 1;

  @override
  Point read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Point(
      id: fields[0] as int,
      district: fields[1] as String,
      city: fields[2] as String,
      pointName: fields[3] as String,
      lat: fields[4] as double,
      lng: fields[5] as double,
      isDealer: fields[6] as String,
      routeDay: fields[7] as String,
      shopName: fields[8] as String,
      ownerName: fields[9] as String,
      ownerPhone: fields[10] as String,
      monthlySaleTv: fields[17] as String,
      monthlySaleRf: fields[18] as String,
      monthlySaleAc: fields[19] as String,
      showroomSize: fields[20] as String,
      files: fields[23] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Point obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.district)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.pointName)
      ..writeByte(4)
      ..write(obj.lat)
      ..writeByte(5)
      ..write(obj.lng)
      ..writeByte(6)
      ..write(obj.isDealer)
      ..writeByte(7)
      ..write(obj.routeDay)
      ..writeByte(8)
      ..write(obj.shopName)
      ..writeByte(9)
      ..write(obj.ownerName)
      ..writeByte(10)
      ..write(obj.ownerPhone)
      ..writeByte(11)
      ..write(obj.competitor1TvWalton)
      ..writeByte(12)
      ..write(obj.competitor1RfWalton)
      ..writeByte(13)
      ..write(obj.competitor2TvVision)
      ..writeByte(14)
      ..write(obj.competitor2RfVision)
      ..writeByte(15)
      ..write(obj.competitor3TvMarcel)
      ..writeByte(16)
      ..write(obj.competitor3RfMinister)
      ..writeByte(17)
      ..write(obj.monthlySaleTv)
      ..writeByte(18)
      ..write(obj.monthlySaleRf)
      ..writeByte(19)
      ..write(obj.monthlySaleAc)
      ..writeByte(20)
      ..write(obj.showroomSize)
      ..writeByte(21)
      ..write(obj.displayOut)
      ..writeByte(22)
      ..write(obj.displayIn)
      ..writeByte(23)
      ..write(obj.files);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PointAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
