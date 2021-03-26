import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_special_days/colors.dart';
import 'package:my_special_days/models/special_day.dart';
import 'package:my_special_days/service/hive_local_db_service.dart';
import 'package:my_special_days/service/locator.dart';

class ShowSpecialDays extends StatefulWidget {
  @override
  _ShowSpecialDaysState createState() => _ShowSpecialDaysState();
}

class _ShowSpecialDaysState extends State<ShowSpecialDays> {
  HiveLocalDbService _hiveLocaldbServices = getIt<HiveLocalDbService>();
  List<SpecialDay> specialDays;
  SlidableController _slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    specialDays = _hiveLocaldbServices.getAllSpecialDay();
    _slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: specialDays.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.appColor,
                    AppColors.appColor_l3,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: new Slidable(
                    controller: _slidableController,
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          specialDays[index].title,
                          style: TextStyle(
                              fontFamily: "BitterBold", fontSize: 25),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          specialDays[index].explanation,
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
                          specialDays[index].getDateFormat(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "BitterRegular",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    secondaryActions: <Widget>[
                      new IconSlideAction(
                        onTap: () {
                          _hiveLocaldbServices
                              .deleteSpecialDay(specialDays[index]);
                          specialDays.remove(specialDays[index]);
                        },
                        caption: 'Delete',
                        color: Colors.red.shade200,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  printSpecialDay() async {
    for (SpecialDay specialDay in specialDays) {
      debugPrint(specialDay.toString());
    }
  }
}
