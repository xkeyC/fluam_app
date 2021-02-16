import 'package:fluam_app/decoder/flarum/base.dart';
import 'package:fluam_app/decoder/flarum/flarum.dart';
import 'package:http/http.dart' as http;

void main() async {
  final http.Client client = http.Client();
  String data =
      (await client.get(Uri.parse("https://discuss.flarum.org/api"))).body;
  client.close();
  print(FlarumSiteData.formBase(FlarumBaseData.formJson(data)).title);
  print(FlarumSiteData.formBase(FlarumBaseData.formJson(data)).apiUrl);
  print(FlarumSiteData.formBase(FlarumBaseData.formJson(data)).welcomeTitle);
  print(FlarumSiteData.formBase(FlarumBaseData.formJson(data)).welcomeMessage);
}
