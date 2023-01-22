import 'package:location/location.dart';
import 'package:device_calendar/device_calendar.dart' hide Location;


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


Future<void> requestCalendarPermission() async {
  var calendarPlugin = DeviceCalendarPlugin();
  // Test if location services are enabled.
  var permissionGranted = await calendarPlugin.hasPermissions();
  if (!permissionGranted.isSuccess) {
    return Future.error('Try later');
  }
  if (!permissionGranted.data!) {
    permissionGranted = await calendarPlugin.requestPermissions();
    if (!permissionGranted.isSuccess) {
      return Future.error('Try later');
    }
    if (!permissionGranted.data!) {
      return Future.error('Calendar permissions are denied');
    }
  }
}
