import 'package:firebase_core/firebase_core.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/core/env/dev_env.dart';
import 'package:vietqr_sms/core/env/env.dart';
import 'package:vietqr_sms/core/env/prod_env.dart';

class EnvConfig {
  static final Env _env = (getEnv() == EnvType.DEV) ? DevEnv() : ProdEnv();

  static String getBankUrl() {
    return _env.getBankUrl();
  }

  static String getBaseUrl() {
    return _env.getBaseUrl();
  }

  static String getUrl() {
    return _env.getUrl();
  }

  static FirebaseOptions getFirebaseConfig() {
    return _env.getFirebaseConfig();
  }

  static EnvType getEnv() {
    const EnvType env = EnvType.DEV;
    return env;
  }
}
