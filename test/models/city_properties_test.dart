import 'package:sloboda/models/city_properties.dart';
import 'package:test/test.dart';

void main() {
  group("City properties (de)serialization tests", () {
    test("CityProps", () {
      var prop = CityProps.bigProps();

      var newProp = CityProps.fromJson(prop.toJson());
      expect(newProp.getByType(CITY_PROPERTIES.CITIZENS),
          equals(prop.getByType(CITY_PROPERTIES.CITIZENS)));

      expect(newProp.getByType(CITY_PROPERTIES.FAITH),
          equals(prop.getByType(CITY_PROPERTIES.FAITH)));

      expect(newProp.getByType(CITY_PROPERTIES.DEFENSE),
          equals(prop.getByType(CITY_PROPERTIES.DEFENSE)));

      expect(newProp.getByType(CITY_PROPERTIES.GLORY),
          equals(prop.getByType(CITY_PROPERTIES.GLORY)));

      expect(newProp.getByType(CITY_PROPERTIES.COSSACKS),
          equals(prop.getByType(CITY_PROPERTIES.COSSACKS)));
    });
  });
}
