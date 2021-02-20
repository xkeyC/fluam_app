import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/io/http.dart';

import 'data/app/FlarumSiteInfo.dart';

class AppWebApi {
  static Future<FlarumSiteInfo> getFlarumSiteData(String siteUrl) async {
    final httpStartTime = DateTime.now().millisecondsSinceEpoch;
    final r = await http.get(siteUrl + "/api");
    final httpUsedTime = DateTime.now().millisecondsSinceEpoch - httpStartTime;
    return FlarumSiteInfo.formDataAndConnectionTime(
        FlarumSiteData.formBase(FlarumBaseData.formJson(r.body)), httpUsedTime);
  }

  static AppHttp _h;

  static AppHttp get http {
    if (_h == null) {
      _h = AppHttp();
    }
    return _h;
  }
}
