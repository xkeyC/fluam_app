// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "c_site_follow" : MessageLookupByLibrary.simpleMessage("这个站点将会出现在您的首页"),
    "c_site_url_label" : MessageLookupByLibrary.simpleMessage("Flarum 站点链接，必须使用 HTTPS"),
    "c_site_url_label_error" : MessageLookupByLibrary.simpleMessage("出错了！请检查网络或链接。"),
    "c_speed_level" : MessageLookupByLibrary.simpleMessage("优秀的连接速度可以提高您的浏览体验。"),
    "title_SPEED_LEVEL" : MessageLookupByLibrary.simpleMessage("速度等级:  "),
    "title_add_site" : MessageLookupByLibrary.simpleMessage("添加 Flarum 站点："),
    "title_add_site_first" : MessageLookupByLibrary.simpleMessage("欢迎！ \n添加您的第一个 Flarum 站点："),
    "title_site_conf" : MessageLookupByLibrary.simpleMessage("站点配置"),
    "title_site_follow" : MessageLookupByLibrary.simpleMessage("关注此站点")
  };
}
