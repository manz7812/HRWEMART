import 'package:flutter/material.dart';

class datetimepick{
  late DateTime startdateTime;
  late DateTime enddateTime;

  Future startpickDateTimesss(BuildContext context) async {
    final date = await pickStartDatessss(context);
    if (date == null) return;

    final time = await pickStartTime(context);
    if (time == null) return;

    // setState(() {
    //   startdateTime = DateTime(
    //     date.year,
    //     date.month,
    //     date.day,
    //     time.hour,
    //     time.minute,
    //   );
    // });
  }

  Future<DateTime?> pickStartDatessss(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        locale: Locale('th'),
        initialDate: startdateTime = initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme:  const ColorScheme.light(
                  primary: Colors.deepPurpleAccent,
                  onSurface: Colors.grey,
                )
            ),
            child: child!,
          );
        });

    if (newdate == null){
      print('ไม่ได้เลือกวันที่');
    }else{
      print('เลือกวันที่เรียบร้อย');
      return newdate;
    }
  }

  Future<TimeOfDay?> pickStartTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      initialTime: startdateTime != null
          ? TimeOfDay(hour: startdateTime.hour, minute: startdateTime.minute)
          : initialTime,
    );

    if (newtime == null){
      print('ไม่ได้เลือกเวลา');
    }else{
      print('เลือกเวลาเรียบร้อย');
      return newtime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Mitr',
      ),
    );
  }
}
