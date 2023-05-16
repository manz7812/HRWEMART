import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bottom_pages/DocLa/Doc_LA.dart';

 class funct extends State<DocLAPage>{
  DateTime? startdateTime2;
  DateTime? enddateTime2;

  TextEditingController Startdatetime2 = TextEditingController();
  TextEditingController EnddatetimeFull2 = TextEditingController();
  TextEditingController day = TextEditingController();

  Future startpickDateTime(BuildContext context) async {
    final date = await pickStartDate(context);
    if (date == null) return;

    final time = await pickStartTime(context);
    if (time == null) return;

    // setState(() {
      startdateTime2 = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    // });
  }

  Future<DateTime?> pickStartDate(BuildContext context) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime(DateTime.now().year - 5);
    var lastDate = DateTime(DateTime.now().year + 5);


    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        locale: Locale('th'),
        initialDate: startdateTime2 = initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        // currentDate: DateTime.now(),
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
      startdateTime2 = newdate;
      var i = DateFormat(DateFormat.WEEKDAY, 'th').format(newdate);
      print(i);




      return newdate;
    }
  }

  Future<TimeOfDay?> pickStartTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 12, minute: 0);
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      confirmText: "ตกลง",
      cancelText: "ยกเลิก",
      helpText: "เลือกเวลา",
      hourLabelText: "ชั่วโมง",
      minuteLabelText: "นาที",
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      initialTime: startdateTime2 != null
          ? TimeOfDay(hour: startdateTime2!.hour, minute: startdateTime2!.minute)
          : initialTime,
    );

    if (newtime == null){
      print('ไม่ได้เลือกเวลา');
    }else{
      print('เลือกเวลาเรียบร้อย');
      return newtime;
    }
  }

  Future endpickDateTime(BuildContext context) async {
    final date = await pickEndDate(context);
    if (date == null) return;

    final time = await pickEndTime(context);
    if (time == null) return;

    setState(() {
      enddateTime2 = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime?> pickEndDate(BuildContext context) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime(DateTime.now().year - 5);
    var lastDate = DateTime(DateTime.now().year + 5);


    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        locale: Locale('th'),
        initialDate: enddateTime2 = initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
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
      enddateTime2 = newdate;
      var diff = enddateTime2!.difference(startdateTime2!).inDays +1;
      print(diff);
      var DOW = List.generate(diff, (index) => index).map((value) =>
          DateFormat(DateFormat.WEEKDAY, 'th').format(startdateTime2!.add(Duration(days: value)))).toList();
      var DOY = List.generate(diff, (index) => index).map((value) =>
          DateFormat("dd/MM/yyyy").format(startdateTime2!.add(Duration(days: value)))).toList();
      print(DOW);
      print(DOY);

      return newdate;
    }
  }

  Future<TimeOfDay?> pickEndTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      confirmText: "ตกลง",
      cancelText: "ยกเลิก",
      helpText: "เลือกเวลา",
      hourLabelText: "ชั่วโมง",
      minuteLabelText: "นาที",
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      initialTime: enddateTime2 != null
          ? TimeOfDay(hour: enddateTime2!.hour, minute: enddateTime2!.minute)
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
    // TODO: implement build
    throw UnimplementedError();
  }

}