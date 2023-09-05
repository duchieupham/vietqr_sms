// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankModelAdapter extends TypeAdapter<BankModel> {
  @override
  final int typeId = 0;

  @override
  BankModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankModel(
      id: fields[0] as String?,
      bankName: fields[1] as String?,
      bankSortName: fields[2] as String?,
      bankAccount: fields[3] as String?,
      transTime: fields[4] as DateTime?,
      transMoney: fields[5] as String?,
      transType: fields[6] as String?,
      transferContent: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BankModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bankName)
      ..writeByte(2)
      ..write(obj.bankSortName)
      ..writeByte(3)
      ..write(obj.bankAccount)
      ..writeByte(4)
      ..write(obj.transTime)
      ..writeByte(5)
      ..write(obj.transMoney)
      ..writeByte(6)
      ..write(obj.transType)
      ..writeByte(7)
      ..write(obj.transferContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
