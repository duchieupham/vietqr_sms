import 'package:hive_flutter/hive_flutter.dart';
import 'package:vietqr_sms/core/pref_utils.dart';
import 'package:vietqr_sms/models/bank_model.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  Box get _box => SharedPrefs.instance.prefs!;

  final String _bankKey = 'bank_key';

  List<BankModel> listBank = [];

  List<BankModel> getBanks() {
    return listBank = _box.values.toList() as List<BankModel>;
  }

  List<BankModel> getAtBank(int index) {
    String bankStart = '';
    String bankEnd = '';
    if (index != 0) {}

    if (_box.values.length > index * 20) {
      bankStart = _box.keyAt(index);
      bankEnd = _box.keyAt(index * 20);
    } else {
      bankStart = _box.keyAt(index);
      bankEnd = _box.keyAt(_box.values.length);
    }

    return listBank = _box
        .valuesBetween(startKey: bankStart, endKey: bankEnd)
        .toList() as List<BankModel>;
  }

  Future<void> addBankToBanks(BankModel bankModel) async {
    if (!_box.containsKey(bankModel.bankSortName)) {
      await _box.put(bankModel.bankSortName, bankModel);
    }
  }

  Future<void> removeBankFromBanks(BankModel bankModel) async {
    await _box.delete(bankModel.bankSortName);
    getBanks();
  }

  Future<void> clearBanks() async {
    await _box.clear();
  }
}
