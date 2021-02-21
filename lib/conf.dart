import 'package:path_provider/path_provider.dart';

import 'io/cache_manager.dart';
import 'io/hive_db.dart';

class AppConf {
  static Future<int> initApp() async {
    /// int dataBase
    await AppDB.init();

    /// init cacheManager
    await AppCacheManager.init(
        (await getTemporaryDirectory()).path + "/Fluam/cache", 1000);
    return 1;
  }

  /// if true,the UI will be Desktop mode.
  static bool get isDesktop => _isDesktop;

  static bool _isDesktop = false;

  static void setDesktop() {
    _isDesktop = true;
  }
}
