// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginOrRegister => 'Login or Register';

  @override
  String get spotlightTitle => 'Spotlight';

  @override
  String get spotlightDescription =>
      'Discover the best articles that are specifically selected for you. The more tags you subscribe to, the better we know what you like.';

  @override
  String get next => 'Next';
}
