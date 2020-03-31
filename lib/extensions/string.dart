extension TimesRepeat on String {
  void timesRepeat(Function f) {
    var parsed;
    try {
      parsed = int.parse(this);
    } catch (e) {
      return;
    }

    for (var i = 0; i < parsed; i++) {
      f();
    }
  }
}
