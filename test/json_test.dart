import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/data/decoder/flarum/src/users.dart';
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
      print("ParentTagsId :${element.parentTags.id}");
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

  print("----------------discussions----------------");

  data = (await client
          .get(Uri.parse("https://discuss.flarum.org/api/discussions")))
      .body;

  final d = FlarumDiscussionsData.formBase(FlarumBaseData.formJson(data));
  d.discussionsList.forEach((element) {
    print(element.title);
  });
  print(d.links.next);

  print("----------------users----------------");

  data = (await client.get(Uri.parse("https://discuss.flarum.org/api/users")))
      .body;

  FlarumUsersData.formBase(FlarumBaseData.formJson(data))
      .usersList
      .forEach((element) {
    print(element.username);
  });

  client.close();
}
