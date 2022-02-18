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

  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "c_site_follow" : MessageLookupByLibrary.simpleMessage("这个网站将会出现在您的首页"),
    "c_site_speed_level" : MessageLookupByLibrary.simpleMessage("优秀的连接速度可以提高您的浏览体验。"),
    "c_site_speed_warning" : MessageLookupByLibrary.simpleMessage("此站点速度不佳，可能会影响您的使用体验，是否继续关注？"),
    "c_site_url_label" : MessageLookupByLibrary.simpleMessage("Flarum 站点链接，必须使用 HTTPS"),
    "c_site_url_label_error" : MessageLookupByLibrary.simpleMessage("出错了！请检网络是否正常，链接是否正确。"),
    "title_SPEED_LEVEL" : MessageLookupByLibrary.simpleMessage("速度等级:  "),
    "title_add_site" : MessageLookupByLibrary.simpleMessage("添加 Flarum 站点："),
    "title_add_site_first" : MessageLookupByLibrary.simpleMessage("欢迎！ \n添加您的第一个 Flarum 站点："),
    "title_no" : MessageLookupByLibrary.simpleMessage("不"),
    "title_retest_speed" : MessageLookupByLibrary.simpleMessage("重新测速"),
    "title_site_conf" : MessageLookupByLibrary.simpleMessage("站点配置"),
    "title_site_follow" : MessageLookupByLibrary.simpleMessage("关注此站点"),
    "title_warning" : MessageLookupByLibrary.simpleMessage("警告"),
    "title_yes" : MessageLookupByLibrary.simpleMessage("是的")
  };
}
