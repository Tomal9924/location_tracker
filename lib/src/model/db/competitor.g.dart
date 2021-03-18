// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competitor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompetitorAdapter extends TypeAdapter<Competitor> {
  @override
  final int typeId = 4;

  @override
  Competitor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Competitor()
      ..id = fields[0] as int
      ..competitorId = fields[1] as String
      ..name = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, Competitor obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.competitorId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetitorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
