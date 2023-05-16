import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:geira_icons/geira_icons.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DocAddTimesPage extends StatefulWidget {
  const DocAddTimesPage({Key? key}) : super(key: key);

  @override
  State<DocAddTimesPage> createState() => _DocAddTimesPageState();
}

class _DocAddTimesPageState extends State<DocAddTimesPage> {

  bool loading = false;
  File? file;

  DateTime? DateAddTime;
  final _dateAddTime = DateFormat('dd/MM/yyyy').format(DateTime.now());
  TextEditingController _dateAddTimeText = TextEditingController();
  TextEditingController _detailText = TextEditingController();
  TextEditingController _time = TextEditingController();


  String? selectedInOut;
  List ListInOut =[
    'เข้า', 'ออก'
  ];
  List ListInOutOt =[
    'เข้า','ออก(OT)'
  ];

  // bool visibilityTag = false;
  bool visibilityObs = false;

  void _changed(bool visibility, String field) {
    setState(() {
      // if (field == "tag"){
      //   visibilityTag = visibility;
      // }
      if (field == "obs"){
        visibilityObs = visibility;
      }
    });
  }


  final List<DateTime> _dates = [];
  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getDataHeader();
    await getDataKa();
    await listHedPon();
  }

  String? selectedHedpon;
  String? checkIMG;
  List ListHedpon =[];
  Future<Null> listHedPon() async{
    String url = pathurl.listHedPon;
    final response = await get(
        Uri.parse(url),
        // headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    ListHedpon = data['data'];
    print(ListHedpon);
  }

  String? dateNow;
  String? status;
  List statusWork = [];
  Future<Null> getDataHeader() async{
    var nows = DateTime.now();
    // dateNow = DateFormat('dd/MM/yyyy').format(nows);
    dateNow = DateFormat.yMMMEd().format(nows);
    var myUTCTime = DateTime.utc(2022, DateTime.june, 5);
    var WD = DateFormat.E('en').format(nows);
    print(WD);
    String url = pathurl.settingHoliday;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      // print(response.statusCode);
      if(data['data'].isNotEmpty){
        switch(WD){
          case "Mon" :
            if(data['data']['mon_day'] == "วันหยุด"){
              print('1');
            }else{
              status = data['data']['mon_day'];
            }
            break;
          case "Tue" :
            if(data['data']['tue_day'] == "วันหยุด"){
              print('2');
            }else{
              status = data['data']['tue_day'];
            }
            break;
          case "Wed" :
            if(data['data']['wed_day'] == "วันหยุด"){
              print('3');
            }else{
              status = data['data']['wed_day'];
            }
            break;
          case "Thu" :
            if(data['data']['thu_day'] == "วันหยุด"){
              print('4');
            }else{
              status = data['data']['thu_day'];
            }
            break;
          case "Fri" :
            if(data['data']['fri_day'] == "วันหยุด"){
              print('5');
            }else{
              status = data['data']['fri_day'];
            }
            break;
          case "Sat" :
            if(data['data']['sat_day'] == "วันหยุด"){
              print('6');
            }else{
              status = data['data']['sat_day'];
            }
            break;
          case "Sun" :
            if(data['data']['sun_day'] == "วันหยุด"){
              status = data['data']['sun_day'];
              print('7');
              setState(() {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  dismissOnTouchOutside: false,
                  // dialogBackgroundColor: Colors.orange,
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  width: 350,
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
                  headerAnimationLoop: false,
                  animType: AnimType.SCALE,
                  // autoHide: Duration(seconds: 3),
                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                  title: 'ไม่สามารถทำรายการได้',
                  desc: 'เนื่องจากเป็นวันหยุดพนักงาน',
                  showCloseIcon: false,
                  btnOkText: "ตกลง",
                  btnOkOnPress: () {
                    Navigator.pop(context);
                  },
                ).show();
              });
            }else{
              status = data['data']['sun_day'];
            }
            break;
        }
      }else{
        status = "ยังไม่มีการตั้งค่าวันทำงาน";
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.black12, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          showCloseIcon: false,
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'ตั้งค่าสถานะวันทำงาน',
          desc: 'กรุณาติดต่อ HR',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      }

    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }

  }

  String? Ka;
  List listKA = [];
  Future<Null> getDataKa() async{
    var nows = DateTime.now();
    var myUTCTime = DateTime.utc(2022, DateTime.june, 5);
    var WD = DateFormat.E('en').format(nows);

    String url = pathurl.settingWKa;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      if(data['data'].isNotEmpty){
        listKA = data['data'];
        switch(WD){
          case "Mon":
            Ka = data['data'][0]['name'];
            break;
          case "Tue" :
            Ka = data['data'][1]['name'];
            break;
          case "Wed" :
            Ka = data['data'][2]['name'];
            break;
          case "Thu" :
            Ka = data['data'][3]['name'];
            break;
          case "Fri" :
            Ka = data['data'][4]['name'];
            break;
          case "Sat" :
            Ka = data['data'][5]['name'];
            break;
          case "Sun" :
            Ka = data['data'][6]['name'];
            break;
        }
      }else{
        return;
      }
    }else if(response.statusCode == 401){
      // popup().sessionexpire(context);
    }

  }


  List date = [
    "2022-08-07",
    "2022-08-13",
    "2022-08-14",
    "2022-08-21",
    "2022-08-28",
  ];

  // bool _predicate(DateTime day) {
  //   // for(var i =0; i < date.length; i++){
  //   //   print("d.${date[i]}");
  //   //   if ((day.isAfter(DateTime(int.parse(date[i].split("-")[0]), int.parse(date[i].split("-")[1]), int.parse(date[i].split("-")[2])))
  //   //       || day.isBefore(DateTime(int.parse(date[i].split("-")[0]), int.parse(date[i].split("-")[1]), int.parse(date[i].split("-")[2]))))) {
  //   //     return true;
  //   //   }
  //   // }
  //
  //
  //   // if ((day.isAfter(DateTime(2020, 1, 10)) ||
  //   //     day.isBefore(DateTime(2020, 1, 15)))) {
  //   //   return true;
  //   // }
  //   // if ((day.isAfter(DateTime(2020, 2, 5)) ||
  //   //     day.isBefore(DateTime(2020, 2, 17)))) {
  //   //   return true;
  //   // }
  //
  //   return false;
  // }

  List event = [];
  String? checkOT;
  Future<Null> checkStatusday(date) async{
    event.clear();
    checkOT = "";
    String url = pathurl.checkStatusday+date;
    final response = await get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    var data = jsonDecode(response.body.toString());
    print(response.statusCode);

    if(response.statusCode == 200){
      print(data['data']);
      for(var i =0; i< data['data'].length; i++){
        if(data['data'][i]['event'] == "วันหยุด"){
          print("popup");
        }else if(data['data'][i]['event'] == "วันลา"){
          print("popup2");
        }else if(data['data'][i]['event'] == "โอที"){
          setState(() {
            checkOT = data['data'][i]['event'];
          });
          print("checkOT = $checkOT");
          event.add(data['data'][i]);
        }else{
          event.add(data['data'][i]);
          print("popup3");
        }
      }
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }else{
      setState(() {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.black12, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          showCloseIcon: false,
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'บันทึกข้อมูลไม่สำเร็จ',
          desc: 'กรุณาลองใหม่อีกครั้ง',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      });
    }
  }

  bool _predicate(DateTime val){
    for(var i = 0; i<date.length; i++){
      DateTime(int.parse(date[i].split("-")[0]), int.parse(date[i].split("-")[1]), int.parse(date[i].split("-")[2]));
      val !=DateTime(2022,08,07);
      return true;
    }
    // val !=DateTime(2022,08,07);
    return false;
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        // selectableDayPredicate: (DateTime val) => val !=  DateTime(2022,08,07) && val !=  DateTime(2022,08,13) && val !=  DateTime(2022,08,14),
        // selectableDayPredicate: _predicate,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year,initialDate.month,initialDate.day-1),
        lastDate: initialDate,
        // firstDate: DateTime(DateTime.now().year - 5),
        // lastDate: DateTime(DateTime.now().year + 5),
        // currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme:  const ColorScheme.light(
                  primary: Colors.deepPurpleAccent,
                  onSurface: Colors.grey,
                ),
            ),

            child: child!,
          );
        });
    if (newdate == null){
      DateAddTime = initialDate;
      print('ไม่ได้เลือกวันที่');
    }else{
      print('เลือกวันที่เรียบร้อย');
      DateAddTime = newdate;
      var checkdate = DateFormat('yyyy-MM-dd').format(DateAddTime!);
      print(checkdate);
      checkStatusday(checkdate);
      return newdate;
    }
  }

  TimeOfDay? selectedTime;
  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 17, minute: 00);
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      initialTime: initialTime,
    );

    if (newtime == null){
      print('ไม่ได้เลือกเวลา');
    }else{
      print('เลือกเวลาเรียบร้อย');
      setState(() {
        // selectedTime = newtime.replacing(hour: newtime.hourOfPeriod);
        selectedTime = newtime;
        print("selectedTime = ${selectedTime}");
        var timeOfday = "${selectedTime!.hour}:${selectedTime!.minute}";
        print("timeOfday = $timeOfday");
        var dt = DateTime(2022,08,01,selectedTime!.hour,selectedTime!.minute);
        var df = DateFormat("HH:mm").format(dt);
        print(df);
        _time.text = df;
      });
      return newtime;
    }
  }

  Future<Null> senddata() async {
    try{
      Random random = Random();
      int i = random.nextInt(1000000);
      String nameIMG = 'wemart$i';
      FormData formData = FormData.fromMap({
        "at_img": checkIMG == "true" ? await MultipartFile.fromFile(
          file!.path,
          filename: nameIMG,
          contentType: MediaType('image','jpg'),
        ) : null,
        "at_date": DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(_dateAddTimeText.text)),
        "at_inout": selectedInOut,
        "at_time" : _time.text,
        "at_remark": selectedHedpon,
        "at_details": _detailText.text
      });
      print(formData.fields);
      String url = pathurl.sendDTHedPon;
      var response = await Dio().post(url,
          data: formData,
          options: Options(
              headers: {"Authorization": "Bearer $token"}
          )
      );

      print(response.statusCode);
      if(response.statusCode == 201){
        context.loaderOverlay.hide();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.green, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          // autoHide: Duration(seconds: 3),
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'บันทึกข้อมูลสำเร็จ',
          showCloseIcon: false,
          btnOkText: "ตกลง",
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();

      }
    }on DioError catch(e){
      print(e.response?.statusCode);
      print(e.response?.data);
      if(e.response?.statusCode == 401){
        context.loaderOverlay.hide();
        popup().sessionexpire(context);
      }else if(e.response?.statusCode == 403){
        var data = e.response?.data['message'];
        context.loaderOverlay.hide();
        setState(() {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO_REVERSED,
            dismissOnTouchOutside: false,
            // dialogBackgroundColor: Colors.orange,
            borderSide: BorderSide(color: Colors.black12, width: 2),
            width: 350,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            showCloseIcon: false,
            // dialogBackgroundColor: Colors.deepPurpleAccent,
            title: 'บันทึกข้อมูลไม่สำเร็จ',
            desc: 'เนื่องจาก ${data} ',
            btnOkText: "ตกลง",
            btnCancelText: "ยกเลิก",
            btnOkOnPress: () {
              // Navigator.pop(context);
            },
          ).show();
        });
      }else{
        setState(() {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO_REVERSED,
            dismissOnTouchOutside: false,
            // dialogBackgroundColor: Colors.orange,
            borderSide: BorderSide(color: Colors.black12, width: 2),
            width: 350,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            showCloseIcon: false,
            // dialogBackgroundColor: Colors.deepPurpleAccent,
            title: 'บันทึกข้อมูลไม่สำเร็จ',
            desc: 'กรุณาลองใหม่อีกครั้ง',
            btnOkText: "ตกลง",
            btnCancelText: "ยกเลิก",
            btnOkOnPress: () {
              // Navigator.pop(context);
            },
          ).show();
        });
      }
    }

  }

  Future<Null> selecImg(ImageSource source) async{
    try{
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 500,
        maxWidth: 500,
      );
      setState(() {
        file = File(result!.path);
      });
    }
    catch(e){

    }
  }


  @override
  void initState() {
    getToken();
    Future.delayed(const Duration(seconds: 2),(){
      setState(() {
        loading = true;
      });
    });
    _dates.add(DateTime(2020, 01, 02));
    _dates.add(DateTime(2020, 01, 03));
    _dates.add(DateTime(2020, 01, 12));
    _dates.add(DateTime(2020, 01, 31));
    _dates.add(DateTime(2020, 02, 29));
    _dates.add(DateTime(2020, 03, 31));
    _detailText.addListener(() {
      setState(() {
        // isButtonActive = controllerhedpon.text.isNotEmpty;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("ขอเพิ่มเวลา"),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(pageContext).pop();
        //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace : Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            // border: Border.all(width: 15, color: Colors.white),
            gradient:  LinearGradient(
              colors: [
                Color(0xff6200EA),
                Colors.white,
              ],
              begin:  FractionalOffset(0.0, 1.0),
              end:  FractionalOffset(1.5, 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                spreadRadius: 5, blurRadius: 30,
                offset: Offset(5, 3),
              ),
            ],
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading ? LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.deepPurpleAccent, size: 50),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Card(
                  child: Container(
                    width: double.infinity,
                    // height: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Text("วันที่ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                            Text("${dateNow?.split(' ')[0]??""} "
                                "${dateNow?.split(' ')[1]??""} "
                                "${dateNow?.split(' ')[2]??""} "
                                "${int.parse(dateNow?.split(' ')[3]?? "")}",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Text("สถานะ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                            Text("${status??""}",style: TextStyle(fontSize: 16,color: Colors.black),),
                          ],
                        ),
                        Expanded(
                          flex: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("กะ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              // Text("${Ka.split(' ')[0].split(':')[0]} : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${Ka?.split(' ')[1].split('[')[1].split("]")[0] ??"" } "
                                  "${Ka?.split(' ')[2] ??"ยังไม่มีการตั้งค่ากะ"}",
                                style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "วันที่",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        TextFormField(
                          autofocus: false,
                          // showCursor: true,
                          readOnly: true,
                          controller: _dateAddTimeText,
                          validator: (value) => (value!.isEmpty) ? '' : null,
                          decoration: const InputDecoration(
                            // filled: true,
                            // fillColor: Colors.grey.shade300,
                            // label: Text("เลือกวันที่"),
                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async{
                            FocusScope.of(context).requestFocus(FocusNode());
                            await pickDate(context);
                            _dateAddTimeText.text = DateFormat('dd/MM/yyyy').format(DateAddTime!);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "ช่วงเวลา",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              // color: selectedHedpon != null ? Colors.transparent: Colors.grey.shade300,
                              border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            focusNode: FocusNode(),
                            icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                            value: selectedInOut,
                            onChanged: (value){
                              setState((){
                                selectedInOut = value as String;
                              });
                              print(event);
                              event.forEach((element) {
                                if(selectedInOut == "เข้า"){
                                  if(element['event'] != "โอที"){
                                    _time.text = element['start'].toString().split(" ")[1];
                                  }
                                }else if(selectedInOut == "ออก"){
                                  if(element['event'] != "โอที"){
                                    _time.text = element["end"].toString().split(" ")[1];
                                  }
                                }else{
                                  _time.text = '';
                                }
                              });
                            },

                            // validator: (value) => (selectedStatus == '' || selectedStatus == null)
                            //     ? ''
                            //     : null,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              // enabled: false,
                              // enabledBorder: OutlineInputBorder(
                              //   // borderSide: BorderSide(
                              //   //     color: Colors.red, width: 2.0
                              //   // ),
                              // ),
                              border:  OutlineInputBorder(
                                // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                              ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(
                              //       color: Colors.grey, width: 2.0),
                              // ),
                            ),
                            items: checkOT == "โอที"
                                 ? ListInOutOt.map((valueItem) {
                                    return DropdownMenuItem<String>(
                                        value: valueItem,child: Text(valueItem)
                                    );
                                  }).toList()
                                :ListInOut.map((valueItem) {
                                  return DropdownMenuItem<String>(
                                      value: valueItem,child: Text(valueItem)
                                  );
                                }).toList(),
                          ),
                        ),

                        const SizedBox(height: 20,),
                        // visibilityObs ?  Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: <Widget>[
                        //     Expanded(
                        //       flex: 1,
                        //       child:  ValueListenableBuilder<DateTime?>(
                        //           valueListenable: dateSub,
                        //           builder: (context, dateVal, child) {
                        //             return InkWell(
                        //                 splashColor: Colors.transparent,
                        //                 highlightColor: Colors.transparent,
                        //                 onTap: () async {
                        //                   DateTime? date = await showDatePicker(
                        //                       context: context,
                        //                       initialDate: DateTime.now(),
                        //                       firstDate: DateTime(DateTime.now().year - 5),
                        //                       lastDate: DateTime(DateTime.now().year + 5),
                        //                       currentDate: DateTime.now(),
                        //                       initialEntryMode: DatePickerEntryMode.calendar,
                        //                       initialDatePickerMode: DatePickerMode.day,
                        //                       builder: (context, child) {
                        //                         return Theme(
                        //                           data: Theme.of(context).copyWith(
                        //                               colorScheme:  ColorScheme.light(
                        //                                 primary: Colors.deepPurpleAccent,
                        //                                 onSurface: Colors.grey,
                        //                               )
                        //                           ),
                        //                           child: child!,
                        //                         );
                        //                       });
                        //                   dateSub.value = date;
                        //                 },
                        //                 child: buildDateTimePicker(
                        //                     dateVal != null ? convertDate(dateVal) : _dateAddTime)
                        //             );
                        //           }),
                        //     ),
                        //      Expanded(
                        //       flex: 1,
                        //       child:  IconButton(
                        //         hoverColor: Colors.transparent,
                        //         splashColor: Colors.transparent,
                        //         color: Colors.red[400],
                        //         icon: const Icon(Icons.cancel, size: 22.0,),
                        //         onPressed: () {
                        //           _changed(false, "obs");
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ) :  Container(),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "เวลา",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            TextFormField(
                              autofocus: false,
                              // focusNode: FocusNode(),
                              showCursor: true,
                              readOnly: true,
                              controller: _time,
                              enabled: checkOT == "โอที" ? true: false,
                              validator: (value) => (value!.isEmpty) ? '' : null,
                              decoration: InputDecoration(
                                // label: Text("เลือกวันที่"),
                                filled: checkOT == "โอที" ? false: true,
                                fillColor: Colors.grey.shade200,
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              onTap: checkOT == "โอที" ?
                                  ()async{
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    await pickTime(context);

                                  }
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "เหตุผล",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          focusNode: FocusNode(),
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectedHedpon,
                          onChanged: (value) {
                            file = null;
                            setState(() {
                              selectedHedpon = value as String;
                              ListHedpon.forEach((element) {
                                if(element['name'] == selectedHedpon){
                                  checkIMG = element['img'];
                                  print(checkIMG);
                                }
                              });
                            });
                          },
                          // validator: (value) => (selectedStatus == '' || selectedStatus == null)
                          //     ? ''
                          //     : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: Colors.grey, width: 2.0
                            //   ),
                            // ),
                            border:  OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: Colors.grey, width: 2.0),
                            // ),
                          ),
                          items: ListHedpon.map((valueItem) {
                            return DropdownMenuItem<String>(
                                value: valueItem['name'].toString(),child: Text(valueItem['name'].toString())
                            );
                          }).toList(),
                        ),
                        SelectPic(),
                        const SizedBox(
                          height: 20,
                        ),

                      ],
                    ),
                  ),
                  elevation: 3,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white)
                  ),
                )
              ],
            ),
          ),
        ),
      )
      :const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            strokeWidth: 5,)
      )
    );
  }

  Widget SelectPic(){
    switch(checkIMG){
      case "false":
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, left: 0.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "รายละเอียด",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            TextFormField(
              autofocus: false,
              // focusNode: FocusNode(),
              showCursor: true,
              readOnly: false,
              controller: _detailText,
              // enabled: selectedStatus != null ? true : false,
              validator: (value) => (value!.isEmpty) ? '' : null,
              maxLines: 6,
              // maxLength: 9999,
              decoration: InputDecoration(
                hintText: " กรุณากรอกรายละเอียด (ไม่บังคับ)",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
              ),

            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.only(right: 16, left: 16),
                    // margin: EdgeInsets.all(10),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //     color: Colors.grey.shade500
                      // ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red ,
                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: (){

                        },
                        child: Text('ยกเลิก')),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.only(right: 16, left: 16),
                    // margin: EdgeInsets.all(10),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //     color: Colors.grey.shade500
                      // ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _dateAddTimeText.text.isNotEmpty &&
                              selectedHedpon != null &&
                              selectedInOut != null
                              ? Colors.green : Colors.grey.shade300,

                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: _dateAddTimeText.text != null &&
                            selectedHedpon != null &&
                            selectedInOut != null
                            ? ()=> setState(() {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            dismissOnTouchOutside: false,
                            // dialogBackgroundColor: Colors.orange,
                            borderSide: BorderSide(color: Colors.black12, width: 2),
                            width: 350,
                            buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
                            headerAnimationLoop: false,
                            animType: AnimType.SCALE,
                            // dialogBackgroundColor: Colors.deepPurpleAccent,
                            title: 'ยืนยันการบันทึก',
                            showCloseIcon: false,
                            btnOkText: "ตกลง",
                            btnCancelText: "ยกเลิก",
                            btnOkOnPress: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              senddata();
                              context.loaderOverlay.show();
                            },
                            btnCancelOnPress: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ).show();
                        })
                            : null,
                        child: Text('บันทึก')),
                  ),
                ),
              ],
            )
          ],
        );
      case "true":
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, left: 0.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "แทรกรูปภาพ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            file == null ?
            Container(
              width: double.infinity,
              // padding: const EdgeInsets.only(right: 16, left: 16),
              // margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: selectedHedpon != null ? Colors.transparent : Colors.grey.shade200,
                  border: Border.all(
                      color: Colors.grey.shade500
                  ),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: TextButton(
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                // minWidth: width,
                // height: 100,
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Icon(GIcons.images,color: Colors.grey,size: 40,),
                    Text('อัพโหลดรูปภาพ',
                        style:  TextStyle(
                          color: selectedHedpon != null ? Colors.blue : Colors.grey,
                        )
                    ),
                    // SizedBox(width: 10),
                  ],
                ),
                onPressed: selectedHedpon != null ?
                    ()=> setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  AwesomeDialog(
                    context: context,
                    // dismissOnTouchOutside: false,
                    // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                    dialogType: DialogType.NO_HEADER,
                    body: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Ink(
                            child:IconButton(
                              icon: Icon(Ionicons.camera_outline),
                              color: Colors.black87,
                              iconSize: 50,
                              splashRadius: 40,
                              disabledColor: Colors.grey,
                              onPressed: () {
                                selecImg(ImageSource.camera);
                              },
                            ),
                            // decoration: ShapeDecoration(
                            //     color: Colors.grey,
                            //     shape: OutlineInputBorder()
                            // ),
                          ),
                          Ink(
                            child:IconButton(
                              icon: Icon(Ionicons.image_outline),
                              color: Colors.black87,
                              iconSize: 50,
                              splashRadius: 40,
                              disabledColor: Colors.grey,
                              onPressed: () {
                                selecImg(ImageSource.gallery);
                              },
                            ),
                            // decoration: ShapeDecoration(
                            //     color: Colors.grey,
                            //     shape: OutlineInputBorder()
                            // ),
                          )
                        ],
                      ),
                    ),
                    // keyboardAware: false,
                    // dialogBackgroundColor: Colors.orange,
                    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    width: 300,
                    buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
                    headerAnimationLoop: false,
                    animType: AnimType.SCALE,
                    autoHide: Duration(seconds: 5),
                    // dialogBackgroundColor: Colors.deepPurpleAccent,
                    // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                    // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                  ).show();
                })
                    :null,
              ),
            )
            :Stack(
              children: <Widget>[
                Image.file(file!),
                Positioned(
                  top: 20,left: 280,width: 50,
                  child: Ink(
                    child:Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(MaterialCommunityIcons.image_edit_outline),
                        color: Colors.amber,
                        iconSize: 30,
                        splashRadius: 50,
                        disabledColor: Colors.grey,
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            // dismissOnTouchOutside: false,
                            // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                            dialogType: DialogType.NO_HEADER,
                            body: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Ink(
                                    child:IconButton(
                                      icon: Icon(Ionicons.camera_outline),
                                      color: Colors.black87,
                                      iconSize: 50,
                                      splashRadius: 40,
                                      disabledColor: Colors.grey,
                                      onPressed: () {
                                        selecImg(ImageSource.camera);
                                      },
                                    ),
                                    // decoration: ShapeDecoration(
                                    //     color: Colors.grey,
                                    //     shape: OutlineInputBorder()
                                    // ),
                                  ),
                                  Ink(
                                    child:IconButton(
                                      icon: Icon(Ionicons.image_outline),
                                      color: Colors.black87,
                                      iconSize: 50,
                                      splashRadius: 40,
                                      disabledColor: Colors.grey,
                                      onPressed: () {
                                        selecImg(ImageSource.gallery);
                                      },
                                    ),
                                    // decoration: ShapeDecoration(
                                    //     color: Colors.grey,
                                    //     shape: OutlineInputBorder()
                                    // ),
                                  )
                                ],
                              ),
                            ),
                            // keyboardAware: false,
                            // dialogBackgroundColor: Colors.orange,
                            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                            width: 300,
                            buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
                            headerAnimationLoop: false,
                            animType: AnimType.SCALE,
                            autoHide: Duration(seconds: 5),
                            // dialogBackgroundColor: Colors.deepPurpleAccent,
                            // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                            // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                          ).show();
                        },
                      ),
                    ),
                    // decoration: ShapeDecoration(
                    //     color: Colors.red,
                    //     shape: OutlineInputBorder()
                    // ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 0.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "รายละเอียด",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            TextFormField(
              autofocus: false,
              // focusNode: FocusNode(),
              showCursor: true,
              readOnly: false,
              controller: _detailText,
              // enabled: selectedStatus != null ? true : false,
              validator: (value) => (value!.isEmpty) ? '' : null,
              maxLines: 6,
              // maxLength: 9999,
              decoration: InputDecoration(
                hintText: " กรุณากรอกรายละเอียด (ไม่บังคับ)",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
              ),

            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.only(right: 16, left: 16),
                    // margin: EdgeInsets.all(10),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //     color: Colors.grey.shade500
                      // ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red ,
                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: (){

                        },
                        child: Text('ยกเลิก')),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.only(right: 16, left: 16),
                    // margin: EdgeInsets.all(10),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //     color: Colors.grey.shade500
                      // ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _dateAddTimeText.text.isNotEmpty &&
                              selectedHedpon != null &&
                              selectedInOut != null &&
                              file != null
                              ? Colors.green : Colors.grey.shade300,

                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: _dateAddTimeText.text != null &&
                            selectedHedpon != null &&
                            selectedInOut != null &&
                            file != null
                            ? ()=> setState(() {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            dismissOnTouchOutside: false,
                            // dialogBackgroundColor: Colors.orange,
                            borderSide: BorderSide(color: Colors.black12, width: 2),
                            width: 350,
                            buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
                            headerAnimationLoop: false,
                            animType: AnimType.SCALE,
                            // dialogBackgroundColor: Colors.deepPurpleAccent,
                            title: 'ยืนยันการบันทึก',
                            showCloseIcon: false,
                            btnOkText: "ตกลง",
                            btnCancelText: "ยกเลิก",
                            btnOkOnPress: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              senddata();
                              context.loaderOverlay.show();
                            },
                            btnCancelOnPress: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ).show();
                        })
                            : null,
                        child: Text('บันทึก')),
                  ),
                ),
              ],
            )
          ],
        );
      default:
        return Container();
    }
  }
}

