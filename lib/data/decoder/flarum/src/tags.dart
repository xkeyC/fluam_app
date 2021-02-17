import 'package:fluam_app/data/decoder/flarum/flarum.dart';

class FlarumTagsData extends FlarumBaseData {
  static const String typeName = "tags";

  final List<FlarumTagData> tagsList;

  FlarumTagsData(Map links, data, List included, this.tagsList)
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
      tagsList.add(FlarumTagData.formBase(FlarumBaseData(
          flarumBaseData.links, element, flarumBaseData.included)));
    });

    return FlarumTagsData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, tagsList);
  }
}

class FlarumTagData extends FlarumBaseData {
  static const String typeName = FlarumTagsData.typeName;

  FlarumTagData(Map links, data, List included) : super(links, data, included);

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

  Map get dataMapSource => this.data["attributes"];

  String get id => this.data["id"];

  String get name => this.dataMapSource["name"];

  String get description => this.dataMapSource["description"];

  String get slug => this.dataMapSource["slug"];

  String get color => this.dataMapSource["color"];

  String get icon => this.dataMapSource["icon"];

  String get discussionCount => this.dataMapSource["discussionCount"];

  int get position => this.dataMapSource["position"];

  bool get isChild => this.dataMapSource["isChild"];

  bool get isHidden => this.dataMapSource["isHidden"];

  String get lastPostedAt => this.dataMapSource["lastPostedAt"];

  bool get canStartDiscussion => this.dataMapSource["canStartDiscussion"];

  bool get canAddToDiscussion => this.dataMapSource["canAddToDiscussion"];

  String get parentTagsId => this.data["relationships"]["parent"]["data"]["id"];
}
