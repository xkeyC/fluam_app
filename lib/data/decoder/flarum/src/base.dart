import 'dart:convert';

import '../flarum.dart';

class FlarumBaseData {
  final FlarumLinkData links;
  final dynamic data;
  final FlarumIncludedData included;
  final String sourceJsonString;

  FlarumBaseData(this.links, this.data, this.included, this.sourceJsonString);

  bool get dataIsMap => this.data is Map;

  bool get dataIsList => this.data is List;

  bool get dataIsNull => this.data == null;

  factory FlarumBaseData.formJson(String jsonData) {
    Map m = json.decode(jsonData);
    return FlarumBaseData(FlarumLinkData.formJsonMap(m["links"]), m["data"],
        FlarumIncludedData.formJsonMapList(m["included"]), jsonData);
  }

  FlarumBaseData forkData(dynamic data) {
    return FlarumBaseData(links, data, included, sourceJsonString);
  }

  @override
  String toString() {
    return {"links": this.links, "data": this.data, "included": this.included}
        .toString();
  }

  bool checkDataType(String typeName) {
    if (dataIsMap) {
      return data["type"] == typeName;
    } else if (dataIsList) {
      if ((data as List).length == 0) {
        return true;
      }
      return data[0]["type"] == typeName;
    } else {
      return false;
    }
  }
}

class FlarumLinkData {
  final String first;
  final String prev;
  final String next;

  FlarumLinkData(this.first, this.prev, this.next);

  factory FlarumLinkData.formJsonMap(Map m) {
    if (m == null) {
      return null;
    }
    return FlarumLinkData(m["first"], m["prev"], m["next"]);
  }
}

class FlarumRelationshipsData {
  final String type;
  final String id;
  final Map sourceMap;

  FlarumRelationshipsData(this.type, this.id, this.sourceMap);

  factory FlarumRelationshipsData.formJsonMap(Map m) {
    if (m == null) {
      return null;
    }
    return FlarumRelationshipsData(m["type"], m["id"], m);
  }

  static List<FlarumRelationshipsData> formJsonMapList(List l) {
    if (l == null) {
      return null;
    }
    List<FlarumRelationshipsData> list = [];
    l.forEach((element) {
      list.add(FlarumRelationshipsData.formJsonMap(element));
    });
    return list;
  }
}

class FlarumIncludedData {
  final Map<String, FlarumPostData> posts;
  final Map<String, FlarumGroupData> groups;
  final Map<String, FlarumDiscussionData> discussions;
  final Map<String, FlarumTagData> tags;
  final Map<String, FlarumUserData> users;

  FlarumIncludedData(
      this.posts, this.groups, this.discussions, this.tags, this.users);

  factory FlarumIncludedData.formJsonMapList(List l) {
    Map<String, FlarumPostData> posts;
    Map<String, FlarumGroupData> groups;
    Map<String, FlarumDiscussionData> discussions;
    Map<String, FlarumTagData> tags;
    Map<String, FlarumUserData> users;

    final rl = FlarumRelationshipsData.formJsonMapList(l);
    if (rl == null) {
      return null;
    }
    rl.forEach((r) {
      switch (r.type) {
        case FlarumPostData.typeName:
          if (posts == null) {
            posts = {};
          }
          final v = FlarumPostData.formBase(FlarumBaseData(
              null, r.sourceMap, null, json.encode(r.sourceMap)));
          posts.addAll({v.id: v});
          break;
        case FlarumGroupData.typeName:
          if (groups == null) {
            groups = {};
          }
          final v = FlarumGroupData.formBase(FlarumBaseData(
              null, r.sourceMap, null, json.encode(r.sourceMap)));
          groups.addAll({v.id: v});
          break;
        case FlarumDiscussionData.typeName:
          if (discussions == null) {
            discussions = {};
          }
          final v = FlarumDiscussionData.formBase(FlarumBaseData(
              null, r.sourceMap, null, json.encode(r.sourceMap)));
          discussions.addAll({v.id: v});
          break;
        case FlarumTagData.typeName:
          if (tags == null) {
            tags = {};
          }
          final v = FlarumTagData.formBase(FlarumBaseData(
              null, r.sourceMap, null, json.encode(r.sourceMap)));
          tags.addAll({v.id: v});
          break;
        case FlarumUserData.typeName:
          if (users == null) {
            users = {};
          }
          final v = FlarumUserData.formBase(FlarumBaseData(
              null, r.sourceMap, null, json.encode(r.sourceMap)));
          users.addAll({v.id: v});
          break;
      }
    });

    return FlarumIncludedData(posts, groups, discussions, tags, users);
  }
}
