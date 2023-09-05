// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String?,
      bankSortName: fields[1] as String?,
      bankAccount: fields[2] as String?,
      transTime: fields[3] as DateTime?,
      transMoney: fields[4] as String?,
      transType: fields[5] as String?,
      transferContent: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bankSortName)
      ..writeByte(2)
      ..write(obj.bankAccount)
      ..writeByte(3)
      ..write(obj.transTime)
      ..writeByte(4)
      ..write(obj.transMoney)
      ..writeByte(5)
      ..write(obj.transType)
      ..writeByte(6)
      ..write(obj.transferContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
