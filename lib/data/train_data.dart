import 'package:location/location.dart';

class TrainData {
  static Map<LocationData, String> getTrainSations() {
    return {
      LocationData.fromMap({
        'latitude': 30.063456,
        'longitude': 31.247608,
      }): 'القاهرة',
      LocationData.fromMap({
        'latitude': 30.456112,
        'longitude': 31.180911,
      }): 'بنها',
      LocationData.fromMap({
        'latitude': 30.547987,
        'longitude': 31.139741,
      }): 'قويسنا',
      LocationData.fromMap({
        'latitude': 30.636923,
        'longitude': 31.079435,
      }): 'بركة السبع',
      LocationData.fromMap({
        'latitude': 30.781251,
        'longitude': 30.994446,
      }): 'طنطا',
      LocationData.fromMap({
        'latitude': 30.819116,
        'longitude': 30.815240,
      }): 'كفر الزيات',
      LocationData.fromMap({
        'latitude': 30.816134,
        'longitude': 30.747961,
      }): 'التوفيقية',
      LocationData.fromMap({
        'latitude': 30.884166,
        'longitude': 30.661788,
      }): 'إيتاي البارود',
      LocationData.fromMap({
        'latitude': 31.034027,
        'longitude': 30.468625,
      }): 'دمنهور',
      LocationData.fromMap({
        'latitude': 31.084992,
        'longitude': 30.309803,
      }): 'أبو حمص',
      LocationData.fromMap({
        'latitude': 31.132463,
        'longitude': 30.130231,
      }): 'كفر الدوار',
      LocationData.fromMap({
        'latitude': 31.220228,
        'longitude': 29.944437,
      }): 'سيدي جابر',
      LocationData.fromMap({
        'latitude': 31.192697,
        'longitude': 29.904817,
      }): 'الإسكندرية',
    };
  }
}
