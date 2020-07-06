import 'package:horizontal_time_picker/horizontal_time_picker.dart';

List<TimeUnit> getDateTimeSlotList(
    int startTimeInHour,
    int endTimeInHour,
    int timeIntervalInMinutes,
    DateTime dateForTime,
    bool showTodaysExpiredSlots) {
  DateTime startDateTime = DateTime(dateForTime.year, dateForTime.month,
      dateForTime.day, startTimeInHour, 0, 0, 0, 0);
  DateTime endDateTime = DateTime(dateForTime.year, dateForTime.month,
      dateForTime.day, endTimeInHour, 0, 0, 0, 0);
  DateTime nextTime = startDateTime;
  List<TimeUnit> timeSlots = [];
  while (endDateTime.difference(nextTime) > Duration(minutes: 0)) {
    if (showTodaysExpiredSlots) {
      timeSlots.add(TimeUnit(nextTime.hour, nextTime.minute));
    } else {
      if (nextTime.difference(DateTime.now()) > Duration(minutes: 0))
        timeSlots.add(TimeUnit(nextTime.hour, nextTime.minute));
    }
    nextTime = nextTime.add(Duration(minutes: timeIntervalInMinutes));
  }

  return timeSlots;
}

List<TimeUnit> getInitialSelectedTimeSlotsList(
    List<DateTime> initialSelectedDates) {
  List<TimeUnit> timeSlots = [];
  if (initialSelectedDates != null) {
    initialSelectedDates.forEach((timeSlot) {
      timeSlots.add(TimeUnit(timeSlot.hour, timeSlot.minute));
    });
  }
  return timeSlots;
}

isTimeSlotDisabled(DateTime dateForTime, TimeUnit timeSlot,
    {List<DateTime> disabledTimeSlots}) {
  DateTime selectedDateTime = DateTime(dateForTime.year, dateForTime.month,
      dateForTime.day, timeSlot.hour, timeSlot.minute, 0, 0, 0);
  bool gotDisabledDate = false;
  if (selectedDateTime.isBefore(DateTime.now())) {
    gotDisabledDate = true;
  } else {
    if (disabledTimeSlots == null || disabledTimeSlots.length == 0) {
      gotDisabledDate = false;
    } else {
      disabledTimeSlots.forEach((date) {
        if (selectedDateTime.difference(date) == Duration(seconds: 0))
          gotDisabledDate = true;
      });
    }
  }
  return gotDisabledDate;
}

isTimeSlotSelected(
    List<TimeUnit> selectedDateTimeSlots, TimeUnit timeSlotIterated) {
  if (selectedDateTimeSlots.isEmpty) return false;
  bool found = false;
  selectedDateTimeSlots.forEach((timeSlot) {
    if (timeSlot.hour == timeSlotIterated.hour &&
        timeSlot.minute == timeSlotIterated.minute) {
      found = true;
    }
  });

  return found;
}
