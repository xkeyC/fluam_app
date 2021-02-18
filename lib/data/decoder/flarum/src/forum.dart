import 'base.dart';

class FlarumSiteData extends FlarumBaseData {
  static const String typeName = "forums";

  FlarumSiteData(FlarumLinkData links, data, FlarumIncludedData included)
      : super(links, data, included);

  factory FlarumSiteData.formBase(FlarumBaseData flarumBaseData) {
    if (flarumBaseData == null || flarumBaseData.dataIsNull) {
      throw "The Data must not be null";
    }
    if (!flarumBaseData.dataIsMap) {
      throw "The Data not FlarumSiteData";
    }
    if (!flarumBaseData.checkDataType(typeName)) {
      throw "The Data not FlarumSiteData";
    }
    return FlarumSiteData(
        flarumBaseData.links, flarumBaseData.data, flarumBaseData.included);
  }

  Map get attributes => this.data["attributes"];

  String get id => this.data["id"];

  String get title => attributes["title"];

  String get description => attributes["description"];

  String get baseUrl => attributes["baseUrl"];

  String get basePath => attributes["basePath"];

  String get apiUrl => attributes["apiUrl"];

  String get welcomeTitle => attributes["welcomeTitle"];

  String get welcomeMessage => attributes["welcomeMessage"];

  String get themePrimaryColor => attributes["themePrimaryColor"];

  String get themeSecondaryColor => attributes["themeSecondaryColor"];

  String get logoUrl => attributes["logoUrl"];

  String get faviconUrl => attributes["faviconUrl"];

  bool get allowSignUp => attributes["allowSignUp"];

  bool get canStartDiscussion => attributes["canStartDiscussion"];

  bool get canViewUserList => attributes["canViewUserList"];

  bool get canViewFlags => attributes["canViewFlags"];

  String get guidelinesUrl => attributes["guidelinesUrl"];

  bool get canRequestUsername => attributes["guidelinesUrl"];

  bool get canRequestNickname => attributes["canRequestNickname"];
}
