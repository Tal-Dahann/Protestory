import 'package:location/location.dart';

Future<void> requestLocationPermission() async {
  var location = Location();
  // Test if location services are enabled.
  var serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return Future.error('Location Services is not enabled');
    }
  }
  var permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return Future.error('Location permissions are denied');
    }
  } else if (permissionGranted == PermissionStatus.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }
}
