import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_special_days/colors.dart';
import 'package:my_special_days/models/special_day.dart';
import 'package:my_special_days/service/hive_local_db_service.dart';
import 'package:my_special_days/service/locator.dart';

class AddSpecialDay extends StatefulWidget {
  @override
  _AddSpecialDayState createState() => _AddSpecialDayState();
}

class _AddSpecialDayState extends State<AddSpecialDay> {
  HiveLocalDbService _hiveLocaldbServices = getIt<HiveLocalDbService>();
  DateTime selectedDate;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController explanationController = new TextEditingController();

  Widget edittext(
    TextEditingController controller,
    String title,
    int maxline,
    int maxlenght,
    Function(String) validator,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: validator,
        controller: controller,
        autofocus: true,
        style: TextStyle(fontFamily: "BitterRegular", fontSize: 20),
        maxLines: maxline,
        maxLength: maxlenght,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appColor, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          hintStyle: TextStyle(fontFamily: "BitterThin"),
          labelText: title,
          labelStyle: TextStyle(fontFamily: "BitterRegular"),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          hintText: title + ' giriniz',
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate == null ? DateTime.now() : selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            edittext(titleController, "Başlık", 1, 30, (validator) {
              if (validator.isEmpty || validator == "")
                return "Burası boş bırakılamaz!";
              else
                return null;
            }),
            edittext(explanationController, "Açıklama", 3, 100, (validator) {
              return null;
            }),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                height: 50,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: AppColors.appColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Tarih seç"
                          : selectedDate.toString().substring(0, 10),
                      style: TextStyle(fontFamily: "BitterRegular", fontSize: 18),
                    ),
                    Icon(Icons.date_range_rounded)
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(50),
                alignment: Alignment.centerRight,
                height: 50,
                child: RaisedButton(
                  onPressed: () => addSpecialDay(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.appColor_l4,
                          AppColors.appColor_l3,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints:
                          const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      // min sizes for Material buttons
                      child: const Text(
                        'EKLE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "BitterBold"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  addSpecialDay() async {
    if (_formKey.currentState.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text("Lütfen Tarih Seçiniz"),
          backgroundColor: AppColors.appColor_l2,
        ));
      } else {
        SpecialDay specialDay = new SpecialDay.wAll(titleController.text,
            explanationController.text, selectedDate, false);
        print(specialDay.toString());
        _hiveLocaldbServices.saveSpecialDay(specialDay);
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text("Başarıyla Eklendi."),
          backgroundColor: AppColors.appColor_l2,
        ));
        titleController.text = "";
        explanationController.text = "";
        selectedDate = null;
      }
    }
  }
}
