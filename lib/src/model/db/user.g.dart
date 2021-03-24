// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      guid: fields[1] as String,
      username: fields[3] as String,
      password: fields[4] as String,
      email: fields[5] as String,
      isActive: fields[6] as bool,
      isDeleted: fields[7] as bool,
      lastUpdatedBy: fields[8] as String,
      lastUpdatedDate: fields[9] as String,
      companyId: fields[10] as String,
      rowState: fields[11] as int,
      isAuthenticated: fields[12] as bool,
      token: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.guid)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.isDeleted)
      ..writeByte(8)
      ..write(obj.lastUpdatedBy)
      ..writeByte(9)
      ..write(obj.lastUpdatedDate)
      ..writeByte(10)
      ..write(obj.companyId)
      ..writeByte(11)
      ..write(obj.rowState)
      ..writeByte(12)
      ..write(obj.isAuthenticated)
      ..writeByte(13)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
