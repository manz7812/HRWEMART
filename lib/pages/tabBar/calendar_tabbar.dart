import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/widjet/event.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTabbarPage extends StatefulWidget {
  const CalendarTabbarPage({Key? key}) : super(key: key);

  @override
  State<CalendarTabbarPage> createState() => _CalendarTabbarPageState();
}

class _CalendarTabbarPageState extends State<CalendarTabbarPage> {

  String? selectedHoliday;
  List ListHoliday = [
    'วันหยุดพนักงาน',
    'วันหยุดนักขัตฤกษ์',
    'ลางาน',
    'เวลาผิดปกติ',
    'ขาดงาน',
  ];

  late Map<DateTime, List<Eventss>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selecteDay = DateTime.now();
  DateTime focuseDay =  DateTime.now();

  List<Eventss> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                  child: Card(
                      child: Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.only(right: 16, left: 16),
                        // margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Container(
                            // padding: const EdgeInsets.only(right: 5, left: 8),
                              alignment: AlignmentDirectional.centerStart,
                              // width: 180,
                              child: Text(
                                ListHoliday.first,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )),
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey.shade700,
                          ),
                          value: selectedHoliday,
                          onChanged: (value) {
                            setState(() {
                              selectedHoliday = value as String;
                            });
                          },
                          items: ListHoliday.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem, child: Text(valueItem));
                          }).toList(),
                        ),
                      ),
                      elevation: 3,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.transparent))),
                ),
              ),
              Card(
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
                child: Container(
                  child: TableCalendar(
                    focusedDay: focuseDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    availableCalendarFormats: const{
                      CalendarFormat.month: "เดือน",
                      CalendarFormat.twoWeeks: "2 สัปดาห์",
                      CalendarFormat.week: "สัปดาห์",
                    },
                    onFormatChanged: (CalendarFormat _format){
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,
                    onDaySelected: (DateTime selectDay, DateTime focusDay){
                      setState(() {
                        selecteDay = selectDay;
                        focuseDay = focusDay;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                        isTodayHighlighted: true,
                        todayDecoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white)
                    ),
                    selectedDayPredicate: (DateTime date){
                      return isSameDay(selecteDay,date);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
