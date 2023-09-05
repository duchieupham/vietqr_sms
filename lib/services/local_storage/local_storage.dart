import 'package:hive/hive.dart';
import 'package:vietqr_sms/models/transaction_model.dart';
import 'package:vietqr_sms/services/local_storage/base_local_storage.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  Type boxType = TransactionModel;

  @override
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<TransactionModel>('${boxName}_0962906213');
    return box;
  }

  @override
  List<TransactionModel> getWishlist(Box box) {
    return box.values.toList() as List<TransactionModel>;
  }

  @override
  Future<void> addProductToWishlist(Box box, TransactionModel model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> removeProductFromWishlist(
      Box box, TransactionModel model) async {
    await box.delete(model.id);
  }

  @override
  Future<void> clearWishlist(Box box) async {
    await box.clear();
  }
}
