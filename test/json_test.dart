import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/data/decoder/flarum/src/tags.dart';
import 'package:http/http.dart' as http;

void main() async {
  final http.Client client = http.Client();
  String data =
      (await client.get(Uri.parse("https://discuss.flarum.org/api"))).body;

  print(FlarumSiteData.formBase(FlarumBaseData.formJson(data)).title);

  data =
      (await client.get(Uri.parse("https://discuss.flarum.org/api/tags"))).body;

  print(FlarumTagsData.formBase(FlarumBaseData.formJson(data)).tagsList.length);

  client.close();
}
