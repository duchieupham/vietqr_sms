import 'package:hive/hive.dart';
import 'package:vietqr_sms/models/transaction_model.dart';

abstract class BaseLocalStorageRepository {
  Future<Box> openBox(String boxName);

  List<TransactionModel> getWishlist(Box box);

  Future<void> addProductToWishlist(Box box, TransactionModel model);

  Future<void> removeProductFromWishlist(Box box, TransactionModel model);

  Future<void> clearWishlist(Box box);
}
