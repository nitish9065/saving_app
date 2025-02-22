// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class cards extends TypeAdapter<BankCard> {
  @override
  final int typeId = 1;

  @override
  BankCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankCard(
      id: fields[0] as int,
      name: fields[1] as String,
      number: fields[2] as String,
      balance: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BankCard obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is cards &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankCardImpl _$$BankCardImplFromJson(Map<String, dynamic> json) =>
    _$BankCardImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      number: json['number'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$BankCardImplToJson(_$BankCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'balance': instance.balance,
    };
