import 'dart:convert';

class FlarumBaseData {
  final Map links;
  final dynamic data;
  final List included;

  FlarumBaseData(this.links, this.data, this.included);

  bool get dataIsMap => this.data is Map;

  bool get dataIsList => this.data is List;

  bool get dataIsNull => this.data == null;

  factory FlarumBaseData.formJson(String jsonData) {
    Map m = json.decode(jsonData);
    return FlarumBaseData(m["links"], m["data"], m["included"]);
  }

  @override
  String toString() {
    return {"links": this.links, "data": this.data, "included": this.included}
        .toString();
  }

  bool checkMapDataType(String typeName) {
    return data["type"] == typeName;
  }
}
