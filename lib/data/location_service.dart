import 'package:location/location.dart';

class LocationService {
  static Stream<LocationData> getLiveLocation() async* {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        yield* getLiveLocation();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        yield* getLiveLocation();
      }
    }

    yield* location.onLocationChanged;
  }

  static Future<LocationData> getLocation() {
    return Location().getLocation();
  }
}
