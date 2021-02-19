import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/io/http.dart';

class AppWebApi {
  static Future<FlarumSiteData> getFlarumSiteData(String siteUrl) async {
    return FlarumSiteData.formBase(
        FlarumBaseData.formJson((await http.get(siteUrl + "/api")).body));
  }

  static AppHttp _h;

  static AppHttp get http {
    if (_h == null) {
      _h = AppHttp();
    }
    return _h;
  }
}
