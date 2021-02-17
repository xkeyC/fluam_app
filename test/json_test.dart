import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:http/http.dart' as http;

void main() async {
  final http.Client client = http.Client();
  print("----------------flarum----------------");
  String data =
      (await client.get(Uri.parse("https://discuss.flarum.org/api"))).body;

  print(FlarumSiteData.formBase(FlarumBaseData.formJson(data)).title);

  print("----------------tags----------------");
  data =
      (await client.get(Uri.parse("https://discuss.flarum.org/api/tags"))).body;

  FlarumTagsData.formBase(FlarumBaseData.formJson(data))
      .tagsList
      .forEach((element) {
    print(
        "TAG: ${element.name} IsChild:${element.isChild} Position:${element.position}");
    if (element.isChild) {
      print("ParentTagsId :${element.parentTagsId}");
    }
  });

  print("----------------groups----------------");

  data = (await client.get(Uri.parse("https://discuss.flarum.org/api/groups")))
      .body;

  FlarumGroupsData.formBase(FlarumBaseData.formJson(data))
      .groupsList
      .forEach((element) {
    print(element.nameSingular);
  });

  print("----------------posts----------------");

  data = (await client.get(Uri.parse("https://discuss.flarum.org/api/posts")))
      .body;

  FlarumPostsData.formBase(FlarumBaseData.formJson(data))
      .postsList
      .forEach((element) {
    print(element.contentHtml);
  });

  client.close();
}
