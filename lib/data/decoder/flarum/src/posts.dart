import 'base.dart';

class FlarumPostsData extends FlarumBaseData {
  static const String typeName = "posts";

  final List<FlarumPostData> postsList;

  FlarumPostsData(Map links, data, List included, this.postsList)
      : super(links, data, included);

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
        flarumBaseData.included, postsList);
  }
}

class FlarumPostData extends FlarumBaseData {
  static const String typeName = "posts";

  FlarumPostData(Map links, data, List included) : super(links, data, included);

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
    return FlarumPostData(
        flarumBaseData.links, flarumBaseData.data, flarumBaseData.included);
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

  String get userId => this.relationships["user"]["data"]["id"];

  String get editedUserId => this.relationships["editedUser"]["data"]["id"];

  String get discussionId => this.relationships["discussion"]["data"]["id"];

  List get likes => this.relationships["discussion"]["data"];

  List get mentionedBy => this.relationships["mentionedBy"]["data"];
}
