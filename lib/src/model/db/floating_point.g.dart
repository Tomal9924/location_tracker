// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floating_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FloatingPointAdapter extends TypeAdapter<FloatingPoint> {
  @override
  final int typeId = 1;

  @override
  FloatingPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FloatingPoint(
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
      monthlySaleTv: fields[11] as String,
      monthlySaleRf: fields[12] as String,
      monthlySaleAc: fields[13] as String,
      showroomSize: fields[14] as String,
      files: fields[15] as String,
      shopSubType: fields[16] as String,
      registeredName: fields[17] as String,
      competitorList: fields[18] as String,
      thana: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FloatingPoint obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.monthlySaleTv)
      ..writeByte(12)
      ..write(obj.monthlySaleRf)
      ..writeByte(13)
      ..write(obj.monthlySaleAc)
      ..writeByte(14)
      ..write(obj.showroomSize)
      ..writeByte(15)
      ..write(obj.files)
      ..writeByte(16)
      ..write(obj.shopSubType)
      ..writeByte(17)
      ..write(obj.registeredName)
      ..writeByte(18)
      ..write(obj.competitorList)
      ..writeByte(19)
      ..write(obj.thana);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloatingPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
