import 'package:sloboda/doc_generator/markdown_generator.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

abstract class StockItem<T> implements MarkdownConvertible {
  String localizedKey;
  String localizedDescriptionKey;
  T type;
  int value;

  StockItem([this.value]);

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(localizedKey);
  }

  String toLocalizedDescriptionString() {
    return SlobodaLocalizations.getForKey(localizedDescriptionKey);
  }

  String toImagePath();

  String toIconPath();

  static StockItem fromType(type, [int value]) {
    throw UnimplementedError();
  }

  MarkdownDocument toMarkDownDocument() {
    var localizedName = SlobodaLocalizations.getForKey(localizedKey);
    MarkdownDocument doc = MarkdownDocument();
    doc.image(toIconPath(), '${localizedName}: ${value.toString()}', true);
    return doc;
  }
}
