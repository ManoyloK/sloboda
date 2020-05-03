import 'dart:collection';

abstract class Stockable<T> {
  Map<T, int> values = {};

  Map<String, dynamic> toJson();

  Stockable(Map<T, int> props) {
    if (props != null) {
      values = Map.from(props);
    }
  }
  List<T> getTypeKeys() {
    return values.keys.toList();
  }

  operator <(Stockable<T> anotherMap) {
    if (anotherMap.values.keys.length < this.values.keys.length) {
      return false;
    }
    var queue = Queue.from(this.values.keys);
    while (queue.isNotEmpty) {
      var element = queue.removeFirst();
      var localValue = this.values[element];
      if (anotherMap.values[element] < (localValue == null ? 0 : localValue)) {
        return false;
      }
    }
    return true;
  }

  operator >(Stockable<T> anotherMap) {
    if (anotherMap.values.keys.length > this.values.keys.length) {
      return false;
    }
    var queue = Queue.from(this.values.keys);
    while (queue.isNotEmpty) {
      var element = queue.removeFirst();
      var localValue = this.values[element];
      if (anotherMap.values[element] > (localValue == null ? 0 : localValue)) {
        return false;
      }
    }
    return true;
  }

  int getByType(T type) {
    return this.values[type];
  }

  addToType(T type, int amount) {
    if (values[type] == null) {
      values[type] = 0;
    }
    values[type] = values[type] + amount;
    if (values[type] < 0) {
      values[type] = 0;
    }
  }

  setType(T type, int amount) {
    values[type] = amount;
  }

  Map<T, int> asMap() {
    return Map.from(values);
  }

  removeFromType(T type, int amount) {
    if (values[type] == null) {
      return;
    }
    values[type] = values[type] - amount;
    if (values[type] < 0) {
      values[type] = 0;
    }
  }

  operator +(Stockable another) {
    if (another != null) {
      this.values.forEach((key, _) {
        if (another.getByType(key) != null) {
          this.addToType(key, another.getByType(key));
        }
      });
    }
  }

  operator -(Stockable another) {
    if (another != null) {
      this.values.forEach((key, _) {
        if (another.getByType(key) != null) {
          this.removeFromType(key, another.getByType(key));
        }
      });
    }
  }

  operator *(int multiplier) {
    this.values.forEach((key, value) {
      var newValue = value * multiplier;
      setType(key, newValue);
    });
  }
}
