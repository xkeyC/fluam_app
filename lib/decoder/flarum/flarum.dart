import 'base.dart';

class FlarumSiteData extends FlarumBaseData {
  static const String typeName = "forums";

  FlarumSiteData(Map links, data, List included) : super(links, data, included);

  factory FlarumSiteData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumSiteData";
    }
    if (!flarumBaseData.checkMapDataType(typeName)) {
      throw "The Data not FlarumSiteData";
    }
    return FlarumSiteData(
        flarumBaseData.links, flarumBaseData.data, flarumBaseData.included);
  }

  Map get dataMapSource => this.data["attributes"];

  String get id => this.data["id"];

  String get title => dataMapSource["title"];

  String get description => dataMapSource["description"];

  String get baseUrl => dataMapSource["baseUrl"];

  String get basePath => dataMapSource["basePath"];

  String get apiUrl => dataMapSource["apiUrl"];

  String get welcomeTitle => dataMapSource["welcomeTitle"];

  String get welcomeMessage => dataMapSource["welcomeMessage"];

  String get themePrimaryColor => dataMapSource["themePrimaryColor"];

  String get themeSecondaryColor => dataMapSource["themeSecondaryColor"];

  String get logoUrl => dataMapSource["logoUrl"];

  String get faviconUrl => dataMapSource["faviconUrl"];

  bool get allowSignUp => dataMapSource["allowSignUp"];

  bool get canStartDiscussion => dataMapSource["canStartDiscussion"];

  bool get canViewUserList => dataMapSource["canViewUserList"];

  bool get canViewFlags => dataMapSource["canViewFlags"];

  String get guidelinesUrl => dataMapSource["guidelinesUrl"];

  bool get canRequestUsername => dataMapSource["guidelinesUrl"];

  bool get canRequestNickname => dataMapSource["canRequestNickname"];
}
