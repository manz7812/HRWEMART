class ModelDataHuman {
  String? reqId;
  ReqPos? reqPos;
  String? reqEmpType;
  String? reqDateWant;
  String? reqGender;
  String? reqEdu;
  String? reqLangTh;
  String? reqOtherSkills;
  String? reqDetails;
  String? reqRemark;
  String? reqStatus;
  String? reqDateCreated;
  ReqEmp? reqEmp;

  ModelDataHuman(
      {this.reqId,
        this.reqPos,
        this.reqEmpType,
        this.reqDateWant,
        this.reqGender,
        this.reqEdu,
        this.reqLangTh,
        this.reqOtherSkills,
        this.reqDetails,
        this.reqRemark,
        this.reqStatus,
        this.reqDateCreated,
        this.reqEmp});

  ModelDataHuman.fromJson(Map<String, dynamic> json) {
    reqId = json['req_id'];
    reqPos = json['req_pos'];
    reqEmpType = json['req_emp_type'];
    reqDateWant = json['req_date_want'];
    reqGender = json['req_gender'];
    reqEdu = json['req_edu'];
    reqLangTh = json['req_lang_th'];
    reqOtherSkills = json['req_other_skills'];
    reqDetails = json['req_details'];
    reqRemark = json['req_remark'];
    reqStatus = json['req_status'];
    reqDateCreated = json['req_date_created'];
    reqEmp = json['req_emp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['req_id'] = this.reqId;
    data['req_pos'] = this.reqPos;
    data['req_emp_type'] = this.reqEmpType;
    data['req_date_want'] = this.reqDateWant;
    data['req_gender'] = this.reqGender;
    data['req_edu'] = this.reqEdu;
    data['req_lang_th'] = this.reqLangTh;
    data['req_other_skills'] = this.reqOtherSkills;
    data['req_details'] = this.reqDetails;
    data['req_remark'] = this.reqRemark;
    data['req_status'] = this.reqStatus;
    data['req_date_created'] = this.reqDateCreated;
    data['req_emp'] = this.reqEmp;

    return data;
  }
}

class ReqPos {
  String? id;
  String? name;

  ReqPos({this.id, this.name});

  ReqPos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ReqEmp {
  String? id;
  String? name;
  String? posId;
  String? posName;

  ReqEmp({this.id, this.name, this.posId, this.posName});

  ReqEmp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    posId = json['pos_id'];
    posName = json['pos_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pos_id'] = this.posId;
    data['pos_name'] = this.posName;
    return data;
  }
}