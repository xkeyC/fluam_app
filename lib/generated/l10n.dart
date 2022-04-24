// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static  S? current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S?> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current;
    });
  }

  static S? of(BuildContext context) {
    return Localizations?.of<S>(context, S);
  }

  /// `Welcome! \nAdd Your First Flarum Site:`
  String? get title_add_site_first {
    return Intl.message(
      'Welcome! \nAdd Your First Flarum Site:',
      name: 'title_add_site_first',
      desc: '',
      args: [],
    );
  }

  /// `Add Flarum Site:`
  String get title_add_site {
    return Intl.message(
      'Add Flarum Site:',
      name: 'title_add_site',
      desc: '',
      args: [],
    );
  }

  /// `Site Conf`
  String get title_site_conf {
    return Intl.message(
      'Site Conf',
      name: 'title_site_conf',
      desc: '',
      args: [],
    );
  }

  /// `SPEED LEVEL:  `
  String get title_SPEED_LEVEL {
    return Intl.message(
      'SPEED LEVEL:  ',
      name: 'title_SPEED_LEVEL',
      desc: '',
      args: [],
    );
  }

  /// `Follow This Site`
  String get title_site_follow {
    return Intl.message(
      'Follow This Site',
      name: 'title_site_follow',
      desc: '',
      args: [],
    );
  }

  /// `WARNING`
  String get title_warning {
    return Intl.message(
      'WARNING',
      name: 'title_warning',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get title_yes {
    return Intl.message(
      'YES',
      name: 'title_yes',
      desc: '',
      args: [],
    );
  }

  /// `NO`
  String get title_no {
    return Intl.message(
      'NO',
      name: 'title_no',
      desc: '',
      args: [],
    );
  }

  /// `RETEST SPEED`
  String get title_retest_speed {
    return Intl.message(
      'RETEST SPEED',
      name: 'title_retest_speed',
      desc: '',
      args: [],
    );
  }

  /// `Flarum site URL,Must use HTTPS`
  String get c_site_url_label {
    return Intl.message(
      'Flarum site URL,Must use HTTPS',
      name: 'c_site_url_label',
      desc: '',
      args: [],
    );
  }

  /// `ERROR! Please check network or URL`
  String get c_site_url_label_error {
    return Intl.message(
      'ERROR! Please check network or URL',
      name: 'c_site_url_label_error',
      desc: '',
      args: [],
    );
  }

  /// `A good connection speed will improve your experience.`
  String get c_site_speed_level {
    return Intl.message(
      'A good connection speed will improve your experience.',
      name: 'c_site_speed_level',
      desc: '',
      args: [],
    );
  }

  /// `The speed of this site is not good, which may affect your experience, do you continue to follow?`
  String get c_site_speed_warning {
    return Intl.message(
      'The speed of this site is not good, which may affect your experience, do you continue to follow?',
      name: 'c_site_speed_warning',
      desc: '',
      args: [],
    );
  }

  /// `This site will show on your Home Page`
  String get c_site_follow {
    return Intl.message(
      'This site will show on your Home Page',
      name: 'c_site_follow',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S?> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S?> load(Locale locale) => 
  
  S.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  static of(BuildContext context) {}
}
