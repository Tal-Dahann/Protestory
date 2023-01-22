import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:protestory/utils/permissions_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/protest.dart';

const String calendarName = "Protestory";
const String calendarIdKey = "calendar_id";
const String calendarPairsKey = "calendar_pairs";
const String calendarSyncKey = "calendar_sync";

const calendarSyncPeriod = Duration(minutes: 5);



Future<bool> syncCalendar(List<Protest> protests) async {
  final calendarPlugin = DeviceCalendarPlugin();
  final prefs = await SharedPreferences.getInstance();
  final timezone = await FlutterNativeTimezone.getLocalTimezone();

  if (!await isSyncingEnabled()) {
    return false;
  }

  try {
    await requestCalendarPermission();
  } catch(e) {
    setSyncing(false);
    return false;
  }

  final calendarId = prefs.getString(calendarIdKey) ??
      (await calendarPlugin.createCalendar(calendarName)).data;
  prefs.setString(calendarIdKey, calendarId!);
  var calendarPairs = {
    for (var pair
    in prefs.getStringList(calendarPairsKey) ?? List<String>.empty())
      (pair).split('::')[0]: (pair).split('::')[1]
  };
  Map<String, String> newPairs = {};
  for (Protest protest in protests) {
    var eventId = calendarPairs[protest.id];
    Event? event;
    if (eventId != null) {
      var result = await calendarPlugin.retrieveEvents(
          calendarId, RetrieveEventsParams(eventIds: [eventId]));
      if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
        event = result.data?.first;
      }
    }
    event ??= Event(calendarId);
    var startTime = TZDateTime.from(
        protest.date.toDate(), timeZoneDatabase.locations[timezone]!);
    event.start = startTime;
    event.end = startTime.add(const Duration(hours: 2));
    event.location = protest.locationName;
    event.description = protest.description;
    event.title = protest.name;

    var result = await calendarPlugin.createOrUpdateEvent(event);

    calendarPairs.remove(protest.id);
    if (result != null && result.isSuccess) {
      newPairs[protest.id] = result.data!;
    }
  }
  for (var eventId in calendarPairs.values) {
    calendarPlugin.deleteEvent(calendarId, eventId);
  }
  prefs.setStringList(calendarPairsKey,
      newPairs.entries.map((e) => "${e.key}::${e.value}").toList());
  return true;
}

Future<bool> isSyncingEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(calendarSyncKey) ?? false;
}

Future<void> setSyncing(bool enabled) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(calendarSyncKey, enabled);
}
