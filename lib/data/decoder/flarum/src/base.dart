import 'dart:convert';

class FlarumBaseData {
  final FlarumLinkData links;
  final dynamic data;
  final List included;

  FlarumBaseData(this.links, this.data, this.included);

  bool get dataIsMap => this.data is Map;

  bool get dataIsList => this.data is List;

  bool get dataIsNull =>
      this.data == null ||
      (dataIsList && (data as List).length == 0) ||
      (dataIsMap) && (data as Map) == {};

  factory FlarumBaseData.formJson(String jsonData) {
    Map m = json.decode(jsonData);
    return FlarumBaseData(
        FlarumLinkData.formJsonMap(m["links"]), m["data"], m["included"]);
  }

  FlarumBaseData forkData(dynamic data) {
    return FlarumBaseData(links, data, included);
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
