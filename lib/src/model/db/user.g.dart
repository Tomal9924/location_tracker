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
      name: fields[2] as String,
      email: fields[3] as String,
      username: fields[4] as String,
      phone: fields[5] as String,
      street: fields[6] as String,
      city: fields[7] as String,
      state: fields[8] as String,
      zip: fields[9] as String,
      profilePicture: fields[10] as String,
      lastLoggedIn: fields[11] as String,
      companyGUID: fields[12] as String,
      companyName: fields[13] as String,
      companyWebsite: fields[14] as String,
      companyLogo: fields[15] as String,
      isActive: fields[16] as bool,
      isDeleted: fields[17] as bool,
      isAuthenticated: fields[18] as bool,
      token: fields[19] as String,
      password: fields[20] as String,
      expiresOn: fields[21] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.guid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.street)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.zip)
      ..writeByte(10)
      ..write(obj.profilePicture)
      ..writeByte(11)
      ..write(obj.lastLoggedIn)
      ..writeByte(12)
      ..write(obj.companyGUID)
      ..writeByte(13)
      ..write(obj.companyName)
      ..writeByte(14)
      ..write(obj.companyWebsite)
      ..writeByte(15)
      ..write(obj.companyLogo)
      ..writeByte(16)
      ..write(obj.isActive)
      ..writeByte(17)
      ..write(obj.isDeleted)
      ..writeByte(18)
      ..write(obj.isAuthenticated)
      ..writeByte(19)
      ..write(obj.token)
      ..writeByte(20)
      ..write(obj.password)
      ..writeByte(21)
      ..write(obj.expiresOn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
