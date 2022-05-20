import 'base.dart';

class FlarumDiscussionsData extends FlarumBaseData {
  static const String typeName = "discussions";

  final List<FlarumDiscussionData> discussionsList;

  FlarumDiscussionsData(
      FlarumLinkData? links,
      data,
      FlarumIncludedData? included,
      String sourceJsonString,
      this.discussionsList)
      : super(links, data, included, sourceJsonString);

  factory FlarumDiscussionsData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsList) {
      throw "The Data not FlarumDiscussionsData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumDiscussionsData";
    }
    final List<FlarumDiscussionData> discussionsList = [];

    (flarumBaseData.data as List).forEach((element) {
      discussionsList
          .add(FlarumDiscussionData.formBase(flarumBaseData.forkData(element)));
    });

    return FlarumDiscussionsData(
        flarumBaseData.links,
        flarumBaseData.data,
        flarumBaseData.included,
        flarumBaseData.sourceJsonString,
        discussionsList);
  }
}

class FlarumDiscussionData extends FlarumBaseData {
  static const String typeName = "discussions";

  FlarumDiscussionData(FlarumLinkData? links, data,
      FlarumIncludedData? included, String sourceJsonString)
      : super(links, data, included, sourceJsonString);

  factory FlarumDiscussionData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumDiscussionsData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumDiscussionsData";
    }
    return FlarumDiscussionData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, flarumBaseData.sourceJsonString);
  }

  String? get id => this.data["id"];

  Map? get attributes => this.data["attributes"];

  String? get title => this.attributes!["title"];

  String? get slug => this.attributes!["slug"];

  int? get commentCount => this.attributes!["commentCount"];

  int? get participantCount => this.attributes!["participantCount"];

  String? get createdAt => this.attributes!["createdAt"];

  String? get lastPostedAt => this.attributes!["lastPostedAt"];

  int? get lastPostNumber => this.attributes!["lastPostNumber"];

  bool? get canReply => this.attributes!["lastPostNumber"];

  bool? get canRename => this.attributes!["canRename"];

  bool? get canDelete => this.attributes!["canDelete"];

  bool? get canHide => this.attributes!["canHide"];

  String? get lastReadAt => this.attributes!["lastReadAt"];

  int? get lastReadPostNumber => this.attributes!["lastReadPostNumber"];

  bool? get isApproved => this.attributes!["isApproved"];

  bool? get isLocked => this.attributes!["isLocked"];

  bool? get canLock => this.attributes!["canLock"];

  bool? get isSticky => this.attributes!["isSticky"];

  bool? get canSticky => this.attributes!["canSticky"];

  bool? get subscription => this.attributes!["subscription"];

  bool? get canTag => this.attributes!["canTag"];

  Map? get relationships => this.data["relationships"];

  FlarumRelationshipsData? get user =>
      FlarumRelationshipsData.formJsonMap(this.relationships!["user"]["data"]);

  FlarumRelationshipsData? get lastPostedUser =>
      FlarumRelationshipsData.formJsonMap(
          this.relationships!["lastPostedUser"]["data"]);

  FlarumRelationshipsData? get firstPost => FlarumRelationshipsData.formJsonMap(
      this.relationships!["firstPost"]["data"]);

  List<FlarumRelationshipsData?> get tags =>
      FlarumRelationshipsData.formJsonMapList(
          this.relationships!["tags"]["data"]);
}
