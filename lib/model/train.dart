import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';
import 'package:train_location_service/data/train_data.dart';
import '../data/location_service.dart';

class Train {
  const Train(
    this.currentStation,
    this.nextStation,
    this.speed,
    this.distanceToNextStation,
    this.timeToNextStation,
  );

  final String currentStation;
  final String nextStation;
  final double speed;
  final double? distanceToNextStation;
  final int? timeToNextStation;

  static Stream<Train> getLiveTrain(bool reversed) async* {
    await for (final currentLocation in LocationService.getLiveLocation()) {
      yield _trainFromLocation(currentLocation, reversed);
    }
  }

  static Future<Train> getTrain(bool reversed) async {
    final currentLocation = await LocationService.getLocation();
    return _trainFromLocation(currentLocation, reversed);
  }

  static Train _trainFromLocation(LocationData currentLocation, bool reversed) {
    final result = _getCurrentAndNextStation(
        TrainData.getTrainSations(), currentLocation, reversed);

    final currentStation = result['currentStation'] as String;
    final nextStation = result['nextStation'] as String;
    final nextStationLocation = result['nextStationLocation'] as LocationData?;

    double speed = currentLocation.speed!; //  m/s
    int? timeToNextStation = ((speed * 3.6).round() == 0 ||
            nextStationLocation == null)
        ? null
        : _distance(currentLocation, nextStationLocation) ~/ speed; // second

    final distanceToNextStation = (nextStationLocation == null)
        ? null
        : _distance(currentLocation, nextStationLocation);

    speed = speed * 3.6; //  km/h

    return Train(
      currentStation,
      nextStation,
      speed,
      distanceToNextStation,
      timeToNextStation,
    );
  }

  static Map<String, dynamic> _getCurrentAndNextStation(
    final Map<LocationData, String> stations,
    LocationData currentLocation,
    bool reversed,
  ) {
    var locations = stations.keys;
    if (reversed) {
      locations = locations.toList().reversed;
    }

    double shortestDistance =
        _distance(currentLocation, locations.elementAt(0));
    int indexOfNearest = 0;
    for (int i = 1; i < locations.length; i++) {
      final distance = _distance(currentLocation, locations.elementAt(i));
      if (distance < shortestDistance) {
        shortestDistance = distance;
        indexOfNearest = i;
      }
    }

    if (shortestDistance > _largestDistanceBetweenStations(locations) + 500) {
      //throw Exception('Location Out Of Range');
      return {
        'currentStation':
            'غير معروف\nإما جهاز تحديد الموقع غير دقيق\nأو أنت بعيد جداً عن السكة الحديد',
        'nextStation': 'غير معروف',
        'nextStationLocation': null,
      };
    }
    if (shortestDistance < 300) {
      return {
        'currentStation': stations[locations.elementAt(indexOfNearest)],
        'nextStation': indexOfNearest == locations.length - 1
            ? 'إنت وصلت يا يوسف حمدالله على السلامة\n🥰🥰🥰🥰🥰\nإنزل يلا'
            : stations[locations.elementAt(indexOfNearest + 1)],
        'nextStationLocation': indexOfNearest == locations.length - 1
            ? locations.elementAt(indexOfNearest)
            : locations.elementAt(indexOfNearest + 1),
      };
    }
    if (_distance(currentLocation, locations.last) >
        _distance(locations.elementAt(indexOfNearest), locations.last)) {
      return {
        'currentStation':
            'متجه إلى ' + stations[locations.elementAt(indexOfNearest)]!,
        'nextStation': stations[locations.elementAt(indexOfNearest)],
        'nextStationLocation': locations.elementAt(indexOfNearest),
      };
    }
    return {
      'currentStation':
          'متجه إلى ' + stations[locations.elementAt(indexOfNearest + 1)]!,
      'nextStation': stations[locations.elementAt(indexOfNearest + 1)],
      'nextStationLocation': locations.elementAt(indexOfNearest + 1),
    };
  }

  static double _distance(LocationData l1, LocationData l2) {
    final lat1 = l1.latitude!;
    final lon1 = l1.longitude!;
    final lat2 = l2.latitude!;
    final lon2 = l2.longitude!;
    const p = 0.017453292519943295; // PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    return 12742000 * asin(sqrt(a)); // 2 * R * 1000; R = 6371 km
  }

  static double _largestDistanceBetweenStations(
    final Iterable<LocationData> locations,
  ) {
    double largestDistance = 0.0;
    for (int i = 0; i < locations.length - 1; i++) {
      largestDistance = max(largestDistance,
          _distance(locations.elementAt(i), locations.elementAt(i + 1)));
    }

    return largestDistance;
  }
}
