import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/bottom_pages/DateTimePage/table_time_work_values.dart';
import 'package:intl/intl.dart';

import '../model/event.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView<Event>(
      key: state,
      width: width,
      onEventTap: (CalendarEventData , DateTime){
        print(DateTime);
      },
    );
  }
}

DateTime get _now => DateTime.now();
class MonthViewWidgets extends StatefulWidget {
  const MonthViewWidgets({Key? key}) : super(key: key);

  @override
  State<MonthViewWidgets> createState() => _MonthViewWidgetsState();
}

class _MonthViewWidgetsState extends State<MonthViewWidgets> {
    GlobalKey<MonthViewState>? state;
    double? width;
    DateTime? minDay;
    DateTime? maxDay;
    Future<Null> getTime()async{
      var d0 = DateTime(_now.year,_now.month-1);
      var nows = DateFormat("yyyy-MM").format(d0);
      var d1 = DateFormat("yyyy-MM-dd").parse("${nows}-1");
      var d2 = DateFormat("yyyy-MM-dd").format(d1);

      var startdate = DateTime.parse(d2);
      minDay = startdate;
      // print(startdate);
      var enddate = DateTime(startdate.year,startdate.month+3,startdate.day-1);
      maxDay = enddate;
      // print(enddate);
    }

    @override
  void initState() {
    getTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MonthView<Event>(
      key: state,
      width: width,
      minMonth: minDay,
      maxMonth: maxDay,
      cellAspectRatio: 0.45,
      onEventTap: (CalendarEventData , DateTime){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            TableTimeWorkValuesPage(event: "${CalendarEventData.event}", date: CalendarEventData.date, description: '${CalendarEventData.description}',)));
        print(CalendarEventData);
        // print(CalendarEventData.event);
        // print(CalendarEventData.date);
        // print(CalendarEventData.description);
      },
      // onCellTap: (List ,DateTime){
      //   print(List);
      // },
    );
  }
}

