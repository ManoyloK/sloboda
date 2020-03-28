import 'package:flutter/material.dart';
import 'package:sloboda/loaders/url_parser.dart';
import 'package:sloboda/models/app_preferences.dart';

class LocaleSelection extends StatefulWidget {
  final Function(Locale locale) onLocaleChanged;
  final Locale locale;

  LocaleSelection({this.locale, this.onLocaleChanged});
  @override
  _LocaleSelectionState createState() => _LocaleSelectionState();
}

class _LocaleSelectionState extends State<LocaleSelection> {
  @override
  Widget build(BuildContext context) {
    return _buildLocaleSelection();
  }

  Widget _buildLocaleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 'uk',
          groupValue: widget.locale.languageCode,
          onChanged: _setNewLocale,
        ),
        Text('UKR'),
        Radio(
          value: 'en',
          groupValue: widget.locale.languageCode,
          onChanged: _setNewLocale,
        ),
        Text('ENG'),
      ],
    );
  }

  void _setNewLocale(String newValue) async {
    UrlParser.updateLanguage(newValue);
    try {
      await AppPreferences.instance.setUILanguage(newValue);
    } catch (e) {
      print('Error saving new ui language to app preferences.');
    }
    if (widget.onLocaleChanged != null) {
      widget.onLocaleChanged(Locale(newValue));
    }
  }
}
