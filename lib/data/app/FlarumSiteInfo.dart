import 'package:fluam_app/data/decoder/flarum/flarum.dart';

class FlarumSiteInfo {
  FlarumSiteData data;

  /// -1:Can't communicate
  /// 0:<500ms
  /// 1:<1s
  /// 2:<2s
  /// 3:<5s
  /// 4:<10s
  /// 5:>10s
  int siteConnectionSpeedLevel;

  FlarumSiteInfo(this.data, this.siteConnectionSpeedLevel);

  factory FlarumSiteInfo.formDataAndConnectionTime(
      FlarumSiteData data, int connectionTime) {
    int siteConnectionSpeedLevel = -1;
    if (connectionTime <= 500) {
      siteConnectionSpeedLevel = 0;
    } else if (connectionTime <= 1000) {
      siteConnectionSpeedLevel = 1;
    } else if (connectionTime <= 2000) {
      siteConnectionSpeedLevel = 2;
    } else if (connectionTime <= 5000) {
      siteConnectionSpeedLevel = 3;
    } else if (connectionTime < 10000) {
      siteConnectionSpeedLevel = 4;
    } else {
      siteConnectionSpeedLevel = 5;
    }
    return FlarumSiteInfo(data, siteConnectionSpeedLevel);
  }
}
