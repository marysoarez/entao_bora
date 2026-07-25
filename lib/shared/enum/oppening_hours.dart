import 'package:entao_bora/shared/enum/week_day_enum.dart';
import 'package:flutter/material.dart';


class OpeningHours {
  final Weekday weekday;
  final TimeOfDay opensAt;
  final TimeOfDay closesAt;

  const OpeningHours({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  });

  bool get is24Hours =>
      opensAt.hour == 0 &&
      opensAt.minute == 0 &&
      closesAt.hour == 23 &&
      closesAt.minute == 59;

  String get formatted {
    String format(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return '${format(opensAt)} às ${format(closesAt)}';
  }
  Map<String, dynamic> toMap() {
  return {
    'weekday': weekday.name,
    'opensAt': {
      'hour': opensAt.hour,
      'minute': opensAt.minute,
    },
    'closesAt': {
      'hour': closesAt.hour,
      'minute': closesAt.minute,
    },
  };
}

factory OpeningHours.fromMap(Map<String, dynamic> map) {
  return OpeningHours(
    weekday: Weekday.values.byName(map['weekday']),
    opensAt: TimeOfDay(
      hour: map['opensAt']['hour'],
      minute: map['opensAt']['minute'],
    ),
    closesAt: TimeOfDay(
      hour: map['closesAt']['hour'],
      minute: map['closesAt']['minute'],
    ),
  );
}
}