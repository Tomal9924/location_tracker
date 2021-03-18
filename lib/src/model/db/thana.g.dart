// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thana.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThanaAdapter extends TypeAdapter<Thana> {
  @override
  final int typeId = 3;

  @override
  Thana read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Thana()
      ..id = fields[0] as int
      ..parentDataKey = fields[1] as String
      ..dataKey = fields[2] as String
      ..displayText = fields[3] as String
      ..dataValue = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Thana obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.parentDataKey)
      ..writeByte(2)
      ..write(obj.dataKey)
      ..writeByte(3)
      ..write(obj.displayText)
      ..writeByte(4)
      ..write(obj.dataValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThanaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
