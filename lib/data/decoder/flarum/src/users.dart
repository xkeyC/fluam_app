import 'package:fluam_app/data/decoder/flarum/flarum.dart';

class FlarumUsersData extends FlarumBaseData {
  static const String typeName = "users";

  final List<FlarumUserData> usersList;

  FlarumUsersData(FlarumLinkData links, data, FlarumIncludedData included,
      String sourceJsonString, this.usersList)
      : super(links, data, included, sourceJsonString);

  factory FlarumUsersData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsList) {
      throw "The Data not FlarumUsersData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumUsersData";
    }

    final List<FlarumUserData> usersList = [];

    (flarumBaseData.data as List).forEach((element) {
      usersList.add(FlarumUserData.formBase(flarumBaseData.forkData(element)));
    });

    return FlarumUsersData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, flarumBaseData.sourceJsonString, usersList);
  }
}

class FlarumUserData extends FlarumBaseData {
  static const String typeName = "users";

  FlarumUserData(FlarumLinkData links, data, FlarumIncludedData included,
      String sourceJsonString)
      : super(links, data, included, sourceJsonString);

  factory FlarumUserData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumUsersData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumUsersData";
    }
    return FlarumUserData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, flarumBaseData.sourceJsonString);
  }

  Map get attributes => this.data["attributes"];

  String get id => this.data["id"];

  String get username => this.attributes["username"];

  String get displayName => this.attributes["displayName"];

  String get avatarUrl => this.attributes["avatarUrl"];

  String get slug => this.attributes["slug"];

  String get joinTime => this.attributes["joinTime"];

  int get discussionCount => this.attributes["discussionCount"];

  int get commentCount => this.attributes["commentCount"];

  bool get canEdit => this.attributes["canEdit"];

  bool get canDelete => this.attributes["canDelete"];

  bool get canSuspend => this.attributes["canSuspend"];

  bool get isBanned => this.attributes["isBanned"];

  bool get canBanIP => this.attributes["canBanIP"];

  bool get canSpamblock => this.attributes["canSpamblock"];

  String get bio => this.attributes["bio"];

  bool get canViewBio => this.attributes["canViewBio"];

  bool get canEditBio => this.attributes["canEditBio"];

  Map get relationships => this.data["relationships"];

  List<FlarumRelationshipsData> get groups =>
      FlarumRelationshipsData.formJsonMapList(relationships["groups"]["data"]);
}
