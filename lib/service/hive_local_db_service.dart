import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:my_special_days/models/special_day.dart';

class HiveLocalDbService {
  Box<String> specialDayBox = Hive.box<String>("sdl");

  Future<void> saveSpecialDay(SpecialDay specialDay) async {
    final encodedComment = jsonEncode(specialDay.toMap());
    await specialDayBox.put(specialDay.id, encodedComment);
  }

  Future<void> deleteSpecialDay(SpecialDay specialDay) async {

    if (specialDayBox != null) {
      for (var key in specialDayBox.keys.toList()) {
        print(specialDayBox.get(key).toString() + "  " + jsonEncode(specialDay.toMap()).toString());
        if (specialDayBox.get(key).toString() == jsonEncode(specialDay.toMap()).toString()) {
          await specialDayBox.delete(key);
        }
      }
    }

  }

  Future<void> deleteAllSpecialDay() async {
    await specialDayBox.deleteAll(specialDayBox.keys.toList());
  }

  List<SpecialDay> getAllSpecialDay() {
    List<SpecialDay> allSpecialDay = [];
    if (specialDayBox != null) {
      for (var key in specialDayBox.keys.toList()) {
        SpecialDay sp = SpecialDay.fromMap(jsonDecode(specialDayBox.get(key)));
        print(sp.toString());
        allSpecialDay.add(sp);
      }
    }
    return allSpecialDay;
  }
}
