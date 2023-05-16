import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EditDataEmployeePage extends StatefulWidget {
  const EditDataEmployeePage({Key? key}) : super(key: key);

  @override
  State<EditDataEmployeePage> createState() => _EditDataEmployeePageState();
}

class _EditDataEmployeePageState extends State<EditDataEmployeePage> {
  DateTime? Birthday;
  TextEditingController _BirthdayText = TextEditingController();

  String? selectedPreName;
  List ListPreName =[
    'นาย', 'นาง', 'หม่อมราชวงศ์',
    'หม่อมหลวง', 'คุณหญิง', 'ว่าที่ร้อยตรี',
    'ร้อยตรี', 'ร้อยโท', 'ร้อยเอก',
    'พันตรี', 'พันโท', 'พันเอก',
    'พันเอกพิเศษ', 'พลตรี', 'พลโท',
    'พลเอก', 'ร้อยตำรวจตรี', 'ร้อยตำรวจโท',
    'ร้อยตำรวจเอก', 'พันตำรวจตรี', 'พันตำรวจโท',
    'พันตำรวจเอก', 'พลตำรวจตรี', 'พลตำรวจโท',
  ];

  String? selectedGender;
  List ListGender =[
    'ชาย', 'หญิง'
  ];

  String? selectedStatus;
  List ListStatus =[
    'โสด', 'สมรสและอยู่ร่วมกันตลอดปี',
    'หม้าย', 'สมรส', 'หย่าร้าง'
  ];

  Future<DateTime?> pickStartDate(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        initialDate: Birthday ?? initialDate,
        firstDate: DateTime(DateTime.now().year - 50),
        lastDate: DateTime(DateTime.now().year + 50),
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
      Birthday = newdate;
      return newdate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('แก้ไขข้อมูลพื้นฐาน'),
        centerTitle: true,
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
        // toolbarHeight:MediaQuery.of(context).size.height/4,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(50),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "คำนำหน้า",
                  style: TextStyle(
                    color: Colors.black87,
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
                value: selectedPreName,
                onChanged: (value) {
                  setState(() {
                    selectedPreName = value as String;
                  });
                },
                validator: (value) => (selectedPreName == '' || selectedPreName == null)
                    ? ''
                    : null,
                // autovalidateMode: AutovalidateMode.onUserInteraction,

                decoration: const InputDecoration(
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //       color: selectedStatus != null
                  //           ? Colors.green
                  //           : Colors.red, width: 2.0
                  //   ),
                  // ),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey, width: 1.0),
                  ),
                ),
                items: ListPreName.map((valueItem) {
                  return DropdownMenuItem<String>(
                      value: valueItem,child: Text(valueItem)
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "ชื่อ(TH)",
                  style: TextStyle(
                    color: Colors.black87,
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
                // readOnly: true,
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "นามสกุล(TH)",
                  style: TextStyle(
                    color: Colors.black87,
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
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "ชื่อเล่น(TH)",
                  style: TextStyle(
                    color: Colors.black87,
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
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "ชื่อ(EN)",
                  style: TextStyle(
                    color: Colors.black87,
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
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "นามสกุล(EN)",
                  style: TextStyle(
                    color: Colors.black87,
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
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "ชื่อเล่น(EN)",
                  style: TextStyle(
                    color: Colors.black87,
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
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "เพศ",
                  style: TextStyle(
                    color: Colors.black87,
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
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //       color: selectedStatus != null
                  //           ? Colors.green
                  //           : Colors.red, width: 2.0
                  //   ),
                  // ),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey, width: 1.0),
                  ),
                ),
                items: ListGender.map((valueItem) {
                  return DropdownMenuItem<String>(
                      value: valueItem,child: Text(valueItem)
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "สถานะ",
                  style: TextStyle(
                    color: Colors.black87,
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
                value: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value as String;
                  });
                },
                validator: (value) => (selectedStatus == '' || selectedStatus == null)
                    ? ''
                    : null,
                // autovalidateMode: AutovalidateMode.onUserInteraction,

                decoration: const InputDecoration(
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //       color: selectedStatus != null
                  //           ? Colors.green
                  //           : Colors.red, width: 2.0
                  //   ),
                  // ),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey, width: 1.0),
                  ),
                ),
                items: ListStatus.map((valueItem) {
                  return DropdownMenuItem<String>(
                      value: valueItem,child: Text(valueItem)
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "วันเกิด",
                  style: TextStyle(
                    color: Colors.black87,
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
                controller: _BirthdayText,
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // label: Text("เลือกวันที่"),
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await pickStartDate(context);
                  _BirthdayText.text = DateFormat('dd/MM/yyyy').format(Birthday!);
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "เบอร์โทรศัพท์",
                  style: TextStyle(
                    color: Colors.black87,
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
                // readOnly: true,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 0),
              Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  "อีเมล",
                  style: TextStyle(
                    color: Colors.black87,
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
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: InputDecoration(
                  // label: Text("เลือกวันที่"),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(right: 20, left: 20),
        // margin: EdgeInsets.all(10),
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          // border: Border.all(
          //     color: Colors.grey.shade500
          // ),
          color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(0)
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor:Colors.green,
              primary: Colors.white,
              // minimumSize: Size(width, 100),
            ),
            onPressed: (){},
            child: Text('บันทึก')),
      ),
    );
  }
}
