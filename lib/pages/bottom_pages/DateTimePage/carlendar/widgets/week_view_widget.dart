import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/event.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WeekView<Event>(
      key: state,
      width: width,
      weekPageHeaderBuilder: (DateTime startDate, DateTime endDate) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.arrow_back_ios, size: 15,),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.arrow_forward_ios, size: 15,),
            ),
          ],
        );
      },
    );
  }
}
DateTime get _now => DateTime.now();
class WeekViewWidgets extends StatefulWidget {
  const WeekViewWidgets({Key? key,}) : super(key: key);

  @override
  State<WeekViewWidgets> createState() => _WeekViewWidgetsState();
}

class _WeekViewWidgetsState extends State<WeekViewWidgets> {
  GlobalKey<WeekViewState>? state;
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
    return WeekView<Event>(
      key: state,
      width: width,
      minDay: minDay,
      maxDay: maxDay,

      // initialDay: DateTime(_now.year,_now.month,_now.day),
      // weekPageHeaderBuilder: (DateTime startDate, DateTime endDate){
      //   return WeekPageHeader(
      //     startDate: DateTime.now(),
      //     endDate: DateTime.now(),
      //
      //   );
      // },
      onEventTap: (events, date) => getTime(),
      // onDateLongPress: (date) => print(date),
    );
  }
}

