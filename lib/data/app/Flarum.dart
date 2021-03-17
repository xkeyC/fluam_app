import 'package:fluam_app/data/app/FlarumSite.dart';
import 'package:fluam_app/data/decoder/flarum/flarum.dart';

class FlarumDiscussionsInfo {
  FlarumSiteInfo site;
  FlarumDiscussionsData data;

  FlarumDiscussionsInfo(this.site, this.data);
}

class FlarumDiscussionInfo {
  FlarumSiteInfo site;
  FlarumDiscussionData data;

  FlarumDiscussionInfo(this.site, this.data);
}
