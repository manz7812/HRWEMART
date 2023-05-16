import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// import 'package:index/api/model_human.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDocHuman extends StatefulWidget {
  final String id;
   EditDocHuman({Key? key, required this.id}) : super(key: key);

  @override
  State<EditDocHuman> createState() => _EditDocHumanState();
}

class _EditDocHumanState extends State<EditDocHuman> {
  bool loading = false;

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getlistpos();
    getdata();
    // print(token);
  }

  // Usermodel? dataH;
  List dataHuman = [];
  Future<Null> getdata() async {
    String url = pathurl.urldataHumanById+widget.id;
    final response =
    await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body);
    // print(data);
    if (response.statusCode == 200) {
      setState(() {
        dataHuman = data['data'];
        print(dataHuman);
      });
    }else{

    }
  }

  String? selectedPos;
  List? ListPos;
  Future<Null> getlistpos() async{
    String UrlPos = pathurl.req_pos;
    final response = await get(
        Uri.parse(UrlPos),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        ListPos = data["data"];
        print(ListPos);
      });
    }
  }

  String? selectedHire;
  List? ListHire;
  Future<Null> getlistemployment_type() async{
    String UrlHire = pathurl.emp_type;
    final response = await get(
      Uri.parse(UrlHire),
      // headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    setState(() {
      ListHire = data["data"];
      // print(ListHire);
    });
  }

  String? selectReason;
  List ListReason =[
    'ทดแทน', 'จ้างเพิ่ม',
  ];

  String? selectedGender;
  List ListGender =[
    {'id': 'M', 'name': 'ชาย'},
    {'id': 'F', 'name': 'หญิง'},
    {'id': '0', 'name': 'ไม่ระบุ'},
  ];

  String? selectedEducation;
  List? ListEducation;
  Future<Null> getlisteducation_level() async{
    String Url = pathurl.edu;
    final response = await get(
      Uri.parse(Url),
      // headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    setState(() {
      ListEducation = data["data"];
      // print(ListEducation);
    });
  }

  String? selectedLang;
  List ListLang =[
    'จำเป็น', 'ไม่จำเป็น'
  ];

  DateTime? dateHuman;
  TextEditingController _dateHumanText = TextEditingController();
  TextEditingController _detial = TextEditingController();
  TextEditingController _skill = TextEditingController();


  Future<DateTime?> pickStartDate(BuildContext context) async {
    final initialDate = dataHuman[0]['req_date_want'];
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        initialDate: dateHuman ?? initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
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
      dateHuman = newdate;
      return newdate;
    }
  }

  Future<Null> senddata(data) async{
    String url = pathurl.urldataHumanById+widget.id;
    final response = await put(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
      body: data,
    );
    print(response.statusCode);

    if(response.statusCode == 200){
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
        // dialogBackgroundColor: Colors.deepPurpleAccent,
        title: 'บันทึกข้อมูลสำเร็จ',
        showCloseIcon: false,
        btnOkText: "ตกลง",
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          },
        ).show();
      });
    }
  }

  @override
  void initState() {
    getToken();
    getlistemployment_type();
    getlisteducation_level();
    print(widget.id);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = true;
        _detial = TextEditingController(text: dataHuman[0]['req_details']);
        _skill = TextEditingController(text: dataHuman[0]['req_other_skills']);
        selectedPos = dataHuman[0]['req_pos']['id'];
        selectedHire = dataHuman[0]['req_emp_type'];
        selectReason = dataHuman[0]['req_remark'];
        // _dateHumanText.value = TextEditingController.fromValue(TextEditingValue(text: '31-05-2022')).value;
        _dateHumanText.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(dataHuman[0]['req_date_want'].toString()));
        selectedEducation = dataHuman[0]['req_edu'];
        selectedGender = dataHuman[0]['req_gender']['id'];
        selectedLang = dataHuman[0]['req_lang_th'];
        dateHuman = DateTime.parse(dataHuman[0]['req_date_want'].toString());
        // radius = 100;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('ขอกำลังพล (แก้ไข)'),
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
            child: Column(
              children: [
                Card(
                  elevation: 3,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white)
                  ),
                  child: Container(
                    width: double.infinity,
                    // height: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Text("วันที่ (ขอ) : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                            Text("${dataHuman[0]['req_date_created']}",style: TextStyle(fontSize: 16,color: Colors.black),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                            Text("${dataHuman[0]['req_id']}",style: TextStyle(fontSize: 16,color: Colors.black),),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "ตำแหน่ง",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectedPos,
                          onChanged: (value) {
                            setState(() {
                              selectedPos = value as String;
                            });
                          },
                          validator: (value) => (selectedPos == '' || selectedPos == null)
                              ? ''
                              : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedPos != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0
                            //   ),
                            // ),
                            border: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedPos != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0),
                            // ),
                          ),
                          items: ListPos?.map((valueItem) {
                            return DropdownMenuItem<String>(
                                value: valueItem['id'].toString(),child: Text(valueItem['name'].toString())
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "ประเภทการจ้าง",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField(
                          // isExpanded: true,
                          // underline: const SizedBox(),
                          // hint: Container(
                          //   // padding: const EdgeInsets.only(right: 5, left: 8),
                          //     alignment: AlignmentDirectional.centerStart,
                          //     // width: 180,
                          //     child: Text(
                          //       ListStatus.first,
                          //       style: const TextStyle(
                          //         color: Colors.black,fontSize: 16,
                          //       ),
                          //     )
                          // ),
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectedHire,
                          onChanged: (value) {
                            setState(() {
                              selectedHire = value as String?;
                            });
                          },
                          validator: (value) => (selectedHire == '' || selectedHire == null)
                              ? ''
                              : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0
                            //   ),
                            // ),
                            border: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0),
                            // ),
                          ),
                          items: ListHire?.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem['name'].toString(),child: Text(valueItem['name'].toString())
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "เหตุผลในการขอ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          // isExpanded: true,
                          // underline: const SizedBox(),
                          // hint: Container(
                          //   // padding: const EdgeInsets.only(right: 5, left: 8),
                          //     alignment: AlignmentDirectional.centerStart,
                          //     // width: 180,
                          //     child: Text(
                          //       ListStatus.first,
                          //       style: const TextStyle(
                          //         color: Colors.black,fontSize: 16,
                          //       ),
                          //     )
                          // ),
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectReason,
                          onChanged: (value) {
                            setState(() {
                              selectReason = value as String;
                            });
                          },
                          validator: (value) => (selectReason == '' || selectReason == null)
                              ? ''
                              : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0
                            //   ),
                            // ),
                            border: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0),
                            // ),
                          ),
                          items: ListReason.map((valueItem) {
                            return DropdownMenuItem<String>(
                                value: valueItem,child: Text(valueItem)
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "วันที่ต้องการ",
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
                          focusNode: FocusNode(),
                          showCursor: true,
                          readOnly: true,
                          controller: _dateHumanText,
                          validator: (value) => (value!.isEmpty) ? '' : null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                            await pickStartDate(context);
                            _dateHumanText.text = DateFormat('dd-MM-yyyy').format(dateHuman!);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "เพศ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          // isExpanded: true,
                          // underline: const SizedBox(),
                          // hint: Container(
                          //   // padding: const EdgeInsets.only(right: 5, left: 8),
                          //     alignment: AlignmentDirectional.centerStart,
                          //     // width: 180,
                          //     child: Text(
                          //       ListStatus.first,
                          //       style: const TextStyle(
                          //         color: Colors.black,fontSize: 16,
                          //       ),
                          //     )
                          // ),
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value as String;
                            });
                          },
                          validator: (value) => (selectedGender == '' || selectedGender == null)
                              ? ''
                              : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0
                            //   ),
                            // ),
                            border: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0),
                            // ),
                          ),
                          items: ListGender.map((valueItem) {
                            return DropdownMenuItem<String>(
                                value: valueItem['id'],child: Text(valueItem['name'])
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "ระดับการศึกษา",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField(
                          // isExpanded: true,
                          // underline: const SizedBox(),
                          // hint: Container(
                          //   // padding: const EdgeInsets.only(right: 5, left: 8),
                          //     alignment: AlignmentDirectional.centerStart,
                          //     // width: 180,
                          //     child: Text(
                          //       ListStatus.first,
                          //       style: const TextStyle(
                          //         color: Colors.black,fontSize: 16,
                          //       ),
                          //     )
                          // ),
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectedEducation,
                          onChanged: (value) {
                            setState(() {
                              selectedEducation = value as String;
                            });
                          },
                          validator: (value) => (selectedEducation == '' || selectedEducation == null)
                              ? ''
                              : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0
                            //   ),
                            // ),
                            border: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0),
                            // ),
                          ),
                          items: ListEducation?.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem['name'].toString(),child: Text(valueItem['name'].toString())
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "การใช้ภาษาไทย",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          // isExpanded: true,
                          // underline: const SizedBox(),
                          // hint: Container(
                          //   // padding: const EdgeInsets.only(right: 5, left: 8),
                          //     alignment: AlignmentDirectional.centerStart,
                          //     // width: 180,
                          //     child: Text(
                          //       ListStatus.first,
                          //       style: const TextStyle(
                          //         color: Colors.black,fontSize: 16,
                          //       ),
                          //     )
                          // ),
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          value: selectedLang,
                          onChanged: (value) {
                            setState(() {
                              selectedLang = value as String;
                            });
                          },
                          validator: (value) => (selectedLang == '' || selectedLang == null)
                              ? ''
                              : null,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0
                            //   ),
                            // ),
                            border: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: selectedHire != null
                            //           ? Colors.green
                            //           : Colors.red, width: 2.0),
                            // ),
                          ),
                          items: ListLang.map((valueItem) {
                            return DropdownMenuItem<String>(
                                value: valueItem,child: Text(valueItem)
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "ทักษะอื่นๆ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        TextFormField(
                          controller: _skill,
                          autofocus: false,
                          // focusNode: FocusNode(),
                          showCursor: true,
                          readOnly: false,
                          enabled: true,
                          validator: (value) => (value!.isEmpty) ? '' : null,
                          maxLines: 6,
                          // maxLength: 9999,
                          onChanged: (val) {
                            RegExp regex = RegExp(r"\n+|,+\n+"); // 1
                            if (regex.hasMatch(val)) { // 2
                              final newVal = val.replaceAll(regex, ",\n"); // 3
                              _skill.text = newVal; // 4
                              _skill.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _skill.text.length)); // 5
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            hintText: "หากไม่มีทักษะ ไม่จำเป็นต้องกรอก",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade700)
                            ),
                          ),
                        ),
                        // emailsContainerUI(),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                          controller: _detial,
                          // focusNode: FocusNode(),
                          showCursor: true,
                          readOnly: false,
                          validator: (value) => (value!.isEmpty) ? '' : null,
                          maxLines: 6,
                          onChanged: (val) {
                            RegExp regex = RegExp(r"\n+|,+\n+"); // 1
                            if (regex.hasMatch(val)) { // 2
                              final newVal = val.replaceAll(regex, ",\n"); // 3
                              _detial.text = newVal; // 4
                              _detial.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _detial.text.length)); // 5
                            }
                          },
                          // maxLength: 9999,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            hintText: "กรุณากรอกรายละเอียด",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade700)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      primary: Colors.white,
                                      // minimumSize: Size(width, 100),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).pop();
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
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: selectedPos != null &&
                                          selectedHire != null &&
                                          selectReason != null &&
                                          _dateHumanText.text != null &&
                                          selectedGender != null &&
                                          selectedEducation != null &&
                                          selectedLang != null &&
                                          _detial.text.isNotEmpty
                                          ? Colors.green : Colors.grey,
                                      primary: Colors.white,
                                      // minimumSize: Size(width, 100),
                                    ),
                                    onPressed: selectedPos != null &&
                                        selectedHire != null &&
                                        selectReason != null &&
                                        _dateHumanText.text != null &&
                                        selectedGender != null &&
                                        selectedEducation != null &&
                                        selectedLang != null &&
                                        _detial.text.isNotEmpty ?
                                        (){
                                      setState(() {
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
                                            context.loaderOverlay.show();
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            var jsdata = {
                                              "req_pos":"${selectedPos}",
                                              "req_emp_type":"${selectedHire}",
                                              "req_date_want":"${_dateHumanText.text = DateFormat('yyyy-MM-dd').format(dateHuman!)}",
                                              "req_gender":"${selectedGender}",
                                              "req_edu":"${selectedEducation}",
                                              "req_lang_th":"${selectedLang}",
                                              "req_other_skills":"${_skill.text}",
                                              "req_details":"${_detial.text}",
                                              "req_remark":"${selectReason}",
                                            };
                                            print(jsdata);
                                            senddata(jsdata);
                                          },
                                          btnCancelOnPress: (){
                                            FocusScope.of(context).requestFocus(FocusNode());
                                          },
                                        ).show();
                                      });

                                    }: null,
                                    child: Text('บันทึก')),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
          :const Center(
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,
            ),
          ),
    );
  }
}
