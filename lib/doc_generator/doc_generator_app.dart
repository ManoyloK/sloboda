import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/locale_selection.dart';

class DocGeneratorApp extends StatefulWidget {
  @override
  _DocGeneratorAppState createState() => _DocGeneratorAppState();
}

class _DocGeneratorAppState extends State<DocGeneratorApp> {
  final TextEditingController textController = TextEditingController();
  final scrollController = ScrollController();
  bool showSource = false;

  @override
  initState() {
    super.initState();
    textController.text = ResourceBuilding.toMarkDownFullDocs().toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: LocaleSelection(
                  locale: SlobodaLocalizations.locale,
                  onLocaleChanged: (Locale locale) {
                    setState(() {
                      SlobodaLocalizations.locale = locale;
                      _updateMarkDown();
                    });
                  },
                ),
              ),
              if (showSource)
                Expanded(
                  flex: 9,
                  child: Container(
                    child: TextField(
                      maxLines: 1000,
                      controller: textController,
                    ),
                  ),
                ),
              if (!showSource)
                Expanded(
                  flex: 9,
                  child: Markdown(
                    controller: scrollController,
                    data: textController.text,
                    imageDirectory: "https://locadeserta.com/sloboda/assets/",
                  ),
                ),
              RaisedButton(
                child: Text("Copy"),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: textController.text,
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text(showSource ? 'Show Markdown' : 'Show Source'),
                onPressed: () {
                  setState(() {
                    showSource = !showSource;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _updateMarkDown() {
    textController.text = ResourceBuilding.toMarkDownFullDocs().toString() +
        CityBuilding.toMarkDownFullDocs().toString();
  }
}
