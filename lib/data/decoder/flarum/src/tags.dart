import 'package:fluam_app/data/decoder/flarum/flarum.dart';

class FlarumTagsData extends FlarumBaseData {
  static const String typeName = "tags";

  final List<FlarumTagData> tagsList;

  FlarumTagsData(
      FlarumLinkData links, data, FlarumIncludedData included, this.tagsList)
      : super(links, data, included);

  factory FlarumTagsData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsList) {
      throw "The Data not FlarumTagsData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumTagsData";
    }

    final List<FlarumTagData> tagsList = [];

    (flarumBaseData.data as List).forEach((element) {
      tagsList.add(FlarumTagData.formBase(flarumBaseData.forkData(element)));
    });

    return FlarumTagsData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, tagsList);
  }
}

class FlarumTagData extends FlarumBaseData {
  static const String typeName = FlarumTagsData.typeName;

  FlarumTagData(FlarumLinkData links, data, FlarumIncludedData included)
      : super(links, data, included);

  factory FlarumTagData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumTagData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumTagData";
    }
    return FlarumTagData(
        flarumBaseData.links, flarumBaseData.data, flarumBaseData.included);
  }

  Map get attributes => this.data["attributes"];

  String get id => this.data["id"];

  String get name => this.attributes["name"];

  String get description => this.attributes["description"];

  String get slug => this.attributes["slug"];

  String get color => this.attributes["color"];

  String get icon => this.attributes["icon"];

  String get discussionCount => this.attributes["discussionCount"];

  int get position => this.attributes["position"];

  bool get isChild => this.attributes["isChild"];

  bool get isHidden => this.attributes["isHidden"];

  String get lastPostedAt => this.attributes["lastPostedAt"];

  bool get canStartDiscussion => this.attributes["canStartDiscussion"];

  bool get canAddToDiscussion => this.attributes["canAddToDiscussion"];

  Map get relationships => this.data["relationships"];

  FlarumRelationshipsData get parentTags =>
      FlarumRelationshipsData.formJsonMap(this.relationships["parent"]["data"]);
}
