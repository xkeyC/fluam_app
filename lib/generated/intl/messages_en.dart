// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "c_site_follow" : MessageLookupByLibrary.simpleMessage("This site will show on your Home Page"),
    "c_site_speed_level" : MessageLookupByLibrary.simpleMessage("A good connection speed will improve your experience."),
    "c_site_speed_warning" : MessageLookupByLibrary.simpleMessage("The speed of this site is not good, which may affect your experience, do you continue to follow?"),
    "c_site_url_label" : MessageLookupByLibrary.simpleMessage("Flarum site URL,Must use HTTPS"),
    "c_site_url_label_error" : MessageLookupByLibrary.simpleMessage("ERROR! Please check network or URL"),
    "title_SPEED_LEVEL" : MessageLookupByLibrary.simpleMessage("SPEED LEVEL:  "),
    "title_add_site" : MessageLookupByLibrary.simpleMessage("Add Flarum Site:"),
    "title_add_site_first" : MessageLookupByLibrary.simpleMessage("Welcome! \\nAdd Your First Flarum Site:"),
    "title_no" : MessageLookupByLibrary.simpleMessage("NO"),
    "title_retest_speed" : MessageLookupByLibrary.simpleMessage("RETEST SPEED"),
    "title_site_conf" : MessageLookupByLibrary.simpleMessage("Site Conf"),
    "title_site_follow" : MessageLookupByLibrary.simpleMessage("Follow This Site"),
    "title_warning" : MessageLookupByLibrary.simpleMessage("WARNING"),
    "title_yes" : MessageLookupByLibrary.simpleMessage("YES")
  };
}
