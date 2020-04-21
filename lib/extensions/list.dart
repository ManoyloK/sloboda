import 'dart:math';

extension Divide<T> on List<T> {
  List<List<T>> divideBy(int number) {
    List<T> list = this;
    List<List<T>> result = [];
    while (list.isNotEmpty) {
      result.add([...list.take(number)]);
      try {
        list = list.sublist(number);
      } catch (e) {
        break;
      }
    }

    return result;
  }
}

extension Takers<T> on List<T> {
  List<T> takeLast(int number) {
    if (number < 0) {
      return List<T>();
    }
    if (length <= number) {
      return this;
    }

    return this.sublist(length - number);
  }

  T takeRandom() {
    int max = this.length;
    Random random = Random();
    int next = random.nextInt(max);
    return this[next];
  }
}
