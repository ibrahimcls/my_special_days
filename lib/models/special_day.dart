import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_special_days/service/hive_local_db_service.dart';
import 'package:my_special_days/service/locator.dart';

class SpecialDay {
  @HiveField(0)
  int id;
  @HiveField(1)
  String _title;
  @HiveField(2)
  String _explanation;
  @HiveField(3)
  DateTime _dateTime;
  @HiveField(4)
  bool _remind;

  Key key;

  SpecialDay();

  @override
  String toString() {
    return 'SpecialDay{_title: $_title, _explanation: $_explanation, _dateTime: $_dateTime, _remind: $_remind}';
  }

  SpecialDay.wAll(
      this._title, this._explanation, this._dateTime, this._remind) {
    int id = new Random().nextInt(100);
    HiveLocalDbService _hiveLocaldbServices = getIt<HiveLocalDbService>();
    for (SpecialDay specialDay in _hiveLocaldbServices.getAllSpecialDay()) {
      if (specialDay.id == id) {
        SpecialDay.wAll(
            this._title, this._explanation, this._dateTime, this._remind);
        return;
      }
    }
    this.id=id;
  }

  String getDateFormat() {
    String formattedDate = DateFormat('d MMMM yyyy').format(this.dateTime);
    return formattedDate;
  }

  bool get remind => _remind;

  set remind(bool value) {
    _remind = value;
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    _dateTime = value;
  }

  String get explanation => _explanation;

  set explanation(String value) {
    _explanation = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['_title'] = _title;
    map['_explanation'] = _explanation;
    map['_dateTime'] = _dateTime.toString();
    map['_remind'] = _remind;
    return map;
  }

  SpecialDay.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this._title = map["_title"];
    this._explanation = map["_explanation"];
    this._dateTime = DateTime.parse(map["_dateTime"]);
    this._remind = map["_remind"];
  }
}
