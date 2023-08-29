import 'package:firebase_core/firebase_core.dart';
import 'package:vietqr_sms/core/env/env.dart';

class ProdEnv implements Env {
  @override
  String getBankUrl() {
    return '';
  }

  @override
  String getBaseUrl() {
    return 'https://api.vietqr.org/vqr/api/';
  }

  @override
  String getUrl() {
    return 'https://api.vietqr.org/vqr/';
  }

  @override
  FirebaseOptions getFirebaseConfig() {
    // return const FirebaseOptions(
    //   apiKey: 'AIzaSyAjPP6Mc3baFUgEsO8o0-J-qmSVegmw2TQ',
    //   appId: '1:84188087131:web:cd322a3f4796be944ed07e',
    //   messagingSenderId: '84188087131',
    //   projectId: 'vietqr-product',
    // );
    throw UnimplementedError();
  }
}
