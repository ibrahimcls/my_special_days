import 'package:flutter/material.dart';
import 'package:my_special_days/colors.dart';
import 'package:my_special_days/models/special_day.dart';
import 'package:my_special_days/service/hive_local_db_service.dart';
import 'package:my_special_days/service/locator.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  DateTime selectedDay;

  Calendar({@required this.selectedDay});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController = new CalendarController();
  HiveLocalDbService _hiveLocaldbServices = getIt<HiveLocalDbService>();
  Map<DateTime, List<SpecialDay>> _events = {};
  String title ="",explanation="",date ="";
  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          events: _events,
          calendarController: _calendarController,
          onDaySelected: (day, events, a) {
            setState(() {
              widget.selectedDay = day;
              SpecialDay specialDay = events[0];
              title = specialDay.title;
              explanation = specialDay.explanation;
              date = specialDay.getDateFormat();
            });
          },
          calendarStyle: CalendarStyle(
            todayColor: AppColors.appColor_l2,
            markersColor: AppColors.appColor_l3,
            selectedColor: AppColors.appColor,
            renderDaysOfWeek: false,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: "BitterBold", fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                explanation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "BitterRegular",
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "BitterRegular",
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _fetchEvents() async {
    _events = {};
    List<SpecialDay> specialDays =
        await _hiveLocaldbServices.getAllSpecialDay();
    for (SpecialDay specialDay in specialDays) {
      List<SpecialDay> list = [];
      list.add(specialDay);
      _events[specialDay.dateTime] = list;
    }
    setState(() {});
  }
}
