import 'base.dart';

class FlarumPostsData extends FlarumBaseData {
  static const String typeName = "posts";

  final List<FlarumPostData> postsList;

  FlarumPostsData(FlarumLinkData links, data, FlarumIncludedData included,
      String sourceJsonString, this.postsList)
      : super(links, data, included, sourceJsonString);

  factory FlarumPostsData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsList) {
      throw "The Data not FlarumPostsData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumPostsData";
    }

    final List<FlarumPostData> postsList = [];

    (flarumBaseData.data as List).forEach((element) {
      postsList.add(FlarumPostData.formBase(flarumBaseData.forkData(element)));
    });

    return FlarumPostsData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, flarumBaseData.sourceJsonString, postsList);
  }
}

class FlarumPostData extends FlarumBaseData {
  static const String typeName = "posts";

  FlarumPostData(FlarumLinkData links, data, FlarumIncludedData included,
      String sourceJsonString)
      : super(links, data, included, sourceJsonString);

  factory FlarumPostData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumPostsData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumPostsData";
    }
    return FlarumPostData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, flarumBaseData.sourceJsonString);
  }

  Map get attributes => this.data["attributes"];

  String get id => this.data["id"];

  int get number => this.attributes["number"];

  String get createdAt => this.attributes["createdAt"];

  String get contentType => this.attributes["contentType"];

  String get contentHtml => this.attributes["contentHtml"];

  String get content => this.attributes["content"];

  String get editedAt => this.attributes["editedAt"];

  bool get canEdit => this.attributes["canEdit"];

  bool get canHide => this.attributes["canHide"];

  bool get isApproved => this.attributes["isApproved"];

  bool get canFlag => this.attributes["canFlag"];

  bool get canLike => this.attributes["canLike"];

  bool get canBanIP => this.attributes["canBanIP"];

  Map get relationships => this.data["relationships"];

  FlarumRelationshipsData get user =>
      FlarumRelationshipsData.formJsonMap(this.relationships["user"]["data"]);

  FlarumRelationshipsData get editedUser => FlarumRelationshipsData.formJsonMap(
      this.relationships["editedUser"]["data"]);

  FlarumRelationshipsData get discussion => FlarumRelationshipsData.formJsonMap(
      this.relationships["discussion"]["data"]);

  List<FlarumRelationshipsData> get likes =>
      FlarumRelationshipsData.formJsonMapList(
          this.relationships["likes"]["data"]);

  List<FlarumRelationshipsData> get mentionedBy =>
      FlarumRelationshipsData.formJsonMapList(
          this.relationships["mentionedBy"]["data"]);
}
