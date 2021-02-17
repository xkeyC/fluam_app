import 'dart:convert';

class FlarumBaseData {
  final Map links;
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
    return FlarumBaseData(m["links"], m["data"], m["included"]);
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
      return data[0]["type"] == typeName;
    } else {
      return false;
    }
  }
}
