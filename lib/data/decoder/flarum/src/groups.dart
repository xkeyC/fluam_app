import 'package:fluam_app/data/decoder/flarum/flarum.dart';

class FlarumGroupsData extends FlarumBaseData {
  static const String typeName = "groups";

  final List<FlarumGroupData> groupsList;

  FlarumGroupsData(Map links, data, List included, this.groupsList)
      : super(links, data, included);

  factory FlarumGroupsData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsList) {
      throw "The Data not FlarumGroupsData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumGroupsData";
    }
    final List<FlarumGroupData> groupsList = [];

    (flarumBaseData.data as List).forEach((element) {
      groupsList
          .add(FlarumGroupData.formBase(flarumBaseData.forkData(element)));
    });

    return FlarumGroupsData(flarumBaseData.links, flarumBaseData.data,
        flarumBaseData.included, groupsList);
  }
}

class FlarumGroupData extends FlarumBaseData {
  static const String typeName = "groups";

  FlarumGroupData(Map links, data, List included)
      : super(links, data, included);

  factory FlarumGroupData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumGroupData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumGroupData";
    }
    return FlarumGroupData(
        flarumBaseData.links, flarumBaseData.data, flarumBaseData.included);
  }

  String get id => this.data["id"];

  Map get attributes => this.data["attributes"];

  String get nameSingular => this.attributes["nameSingular"];

  String get namePlural => this.attributes["namePlural"];

  String get color => this.attributes["color"];

  String get icon => this.attributes["icon"];

  int get isHidden => this.attributes["isHidden"];
}
