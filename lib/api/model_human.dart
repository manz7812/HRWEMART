import 'dart:convert';

Usermodel usermodelFromMap(String str) => Usermodel.fromMap(json.decode(str));

String usermodelToMap(Usermodel data) => json.encode(data.toMap());

class Usermodel {
  Usermodel({
    required this.reqId,
    required this.reqPos,
    required this.reqEmpType,
    required this.reqDateWant,
    required this.reqGender,
    required this.reqEdu,
    required this.reqLangTh,
    required this.reqOtherSkills,
    required this.reqDetails,
    required this.reqRemark,
    required this.reqStatus,
    required this.reqDateCreated,
    required this.reqEmp,
    required this.reqApprove,
  });

  String reqId;
  Req reqPos;
  String reqEmpType;
  DateTime reqDateWant;
  Req reqGender;
  String reqEdu;
  String reqLangTh;
  String reqOtherSkills;
  String reqDetails;
  String reqRemark;
  String reqStatus;
  String reqDateCreated;
  ReqEmp reqEmp;
  List<ReqApprove> reqApprove;

  factory Usermodel.fromMap(Map<String, dynamic> json) => Usermodel(
    reqId: json["req_id"],
    reqPos: Req.fromMap(json["req_pos"]) ,
    reqEmpType: json["req_emp_type"],
    reqDateWant: DateTime.parse(json["req_date_want"]),
    reqGender: Req.fromMap(json["req_gender"]),
    reqEdu: json["req_edu"],
    reqLangTh: json["req_lang_th"],
    reqOtherSkills: json["req_other_skills"],
    reqDetails: json["req_details"],
    reqRemark: json["req_remark"],
    reqStatus: json["req_status"],
    reqDateCreated: json["req_date_created"],
    reqEmp: ReqEmp.fromMap(json["req_emp"]),
    reqApprove: List<ReqApprove>.from(json["req_approve"].map((x) => ReqApprove.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "req_id": reqId,
    "req_pos": reqPos.toMap(),
    "req_emp_type": reqEmpType,
    "req_date_want": reqDateWant.toIso8601String(),
    "req_gender": reqGender.toMap(),
    "req_edu": reqEdu,
    "req_lang_th": reqLangTh,
    "req_other_skills": reqOtherSkills,
    "req_details": reqDetails,
    "req_remark": reqRemark,
    "req_status": reqStatus,
    "req_date_created": reqDateCreated,
    "req_emp": reqEmp.toMap(),
    "req_approve": List<dynamic>.from(reqApprove.map((x) => x.toMap())),
  };
}

class ReqApprove {
  ReqApprove({
    required this.no,
    required this.posName,
    required this.status,
    required this.imgUrl,
  });

  int no;
  String posName;
  String status;
  String imgUrl;

  factory ReqApprove.fromMap(Map<String, dynamic> json) => ReqApprove(
    no: json["No"],
    posName: json["pos_name"],
    status: json["status"],
    imgUrl: json["img_url"],
  );

  Map<String, dynamic> toMap() => {
    "No": no,
    "pos_name": posName,
    "status": status,
    "img_url": imgUrl,
  };
}

class ReqEmp {
  ReqEmp({
    required this.id,
    required this.name,
    required this.posId,
    required this.posName,
  });

  String id;
  String name;
  String posId;
  String posName;

  factory ReqEmp.fromMap(Map<String, dynamic> json) => ReqEmp(
    id: json["id"],
    name: json["name"],
    posId: json["pos_id"],
    posName: json["pos_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "pos_id": posId,
    "pos_name": posName,
  };
}

class Req {
  Req({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Req.fromMap(Map<String, dynamic> json) => Req(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
