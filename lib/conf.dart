import 'package:path_provider/path_provider.dart';

import 'data/app/FlarumSiteInfo.dart';
import 'io/cache_manager.dart';
import 'io/hive_db.dart';

class AppConf {
  static List<FlarumSiteInfo> _sites;

  static List<FlarumSiteInfo> get sites => _sites;

  static Future<int> initApp() async {
    /// int dataBase
    await AppDB.init();

    /// init cacheManager
    await AppCacheManager.init(
        (await getTemporaryDirectory()).path + "/Fluam/cache", 1000);

    _sites = await FlarumSiteInfo.getSitesList();

    return 1;
  }

  /// if true,the UI will be Desktop mode.
  static bool get isDesktop => _isDesktop;

  static bool _isDesktop = false;

  static void setDesktop() {
    _isDesktop = true;
  }
}
