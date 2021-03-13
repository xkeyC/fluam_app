import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/data/decoder/flarum/src/forum.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:hive/hive.dart';

class FlarumSiteInfo {
  static const String dbName = "site_info";

  final String id;
  FlarumSiteData _data;

  FlarumSiteData get data => this._data;

  /// -1:Can't communicate
  /// 0:<500ms
  /// 1:<1s
  /// 2:<2s
  /// 3:<5s
  /// 4:<10s
  /// 5:>10s
  int _siteConnectionSpeedLevel;

  int get siteConnectionSpeedLevel => this._siteConnectionSpeedLevel;

  bool following;

  final int lastUpdateTime;

  FlarumSiteInfo(this.id, this._data, this._siteConnectionSpeedLevel,
      this.following, this.lastUpdateTime);

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

    return FlarumSiteInfo(StringUtil.getSha1(data.baseUrl), data,
        siteConnectionSpeedLevel, false, DateTime.now().millisecondsSinceEpoch);
  }

  factory FlarumSiteInfo.formMap(Map m) {
    String id = m["id"];
    FlarumSiteData data =
        FlarumSiteData.formBase(FlarumBaseData.formJson(m["data"]));
    int siteConnectionSpeedLevel = m["level"];
    bool following = m["following"];
    int lastUpdateTime = m["lastUpdateTime"];
    return FlarumSiteInfo(
        id, data, siteConnectionSpeedLevel, following, lastUpdateTime);
  }

  static Future<List<FlarumSiteInfo>> getSitesList(
      {bool onlyFollowing = false}) async {
    final box = await Hive.openBox(dbName);
    List<FlarumSiteInfo> list = [];
    box.values.forEach((element) {
      final info = FlarumSiteInfo.formMap(element);
      if (onlyFollowing) {
        if (info.following) {
          list.add(info);
        }
      } else {
        list.add(info);
      }
    });
    return list;
  }

  static Future<bool> hasSite(String url) async {
    final box = await Hive.openBox(dbName);
    return box.keys.contains(StringUtil.getSha1(url));
  }

  Future<void> saveSite() async {
    final box = await Hive.openBox(dbName);
    return box.put(id, {
      "id": id,
      "data": data.sourceJsonString,
      "level": siteConnectionSpeedLevel,
      "following": following,
      "lastUpdateTime": lastUpdateTime
    });
  }
}

class FlarumSitePageIndex {
  final FlarumSiteData data;
  final int index;

  FlarumSitePageIndex(this.data, this.index);
}
