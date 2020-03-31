extension TimesRepeat on int {
  void timesRepeat(Function f) {
    for (var i = 0; i < this; i++) {
      f();
    }
  }
}
