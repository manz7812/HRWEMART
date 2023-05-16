class EmployeeModel {
  String? id;
  String? name;
  String? nickName;
  String? gender;
  String? nationality;
  String? religion;
  String? status;
  String? cardId;
  String? posId;
  String? level;
  String? birthday;
  String? email;
  String? tel;
  String? dateStart;
  String? datePacking;
  String? experience;
  String? salary;
  String? ssoId;
  String? taxId;
  String? payment;
  String? bank;
  String? bankBranch;
  String? bankId;
  String? company;
  String? department;
  String? section;
  String? position;
  String? imgUrl;

  EmployeeModel(
      {this.id,
        this.name,
        this.nickName,
        this.gender,
        this.nationality,
        this.religion,
        this.status,
        this.cardId,
        this.posId,
        this.level,
        this.birthday,
        this.email,
        this.tel,
        this.dateStart,
        this.datePacking,
        this.experience,
        this.salary,
        this.ssoId,
        this.taxId,
        this.payment,
        this.bank,
        this.bankBranch,
        this.bankId,
        this.company,
        this.department,
        this.section,
        this.position,
        this.imgUrl
      });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickName = json['nick_name'];
    gender = json['gender'];
    nationality = json['nationality'];
    religion = json['religion'];
    status = json['status'];
    cardId = json['card_id'];
    posId = json['pos_id'];
    level = json['level'];
    birthday = json['birthday'];
    email = json['email'];
    tel = json['tel'];
    dateStart = json['date_start'];
    datePacking = json['date_packing'];
    experience = json['experience'];
    salary = json['salary'];
    ssoId = json['sso_id'];
    taxId = json['tax_id'];
    payment = json['payment'];
    bank = json['bank'];
    bankBranch = json['bank_branch'];
    bankId = json['bank_id'];
    company = json['company'];
    department = json['department'];
    section = json['section'];
    position = json['position'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nick_name'] = this.nickName;
    data['gender'] = this.gender;
    data['nationality'] = this.nationality;
    data['religion'] = this.religion;
    data['status'] = this.status;
    data['card_id'] = this.cardId;
    data['pos_id'] = this.posId;
    data['level'] = this.level;
    data['birthday'] = this.birthday;
    data['email'] = this.email;
    data['tel'] = this.tel;
    data['date_start'] = this.dateStart;
    data['date_packing'] = this.datePacking;
    data['experience'] = this.experience;
    data['salary'] = this.salary;
    data['sso_id'] = this.ssoId;
    data['tax_id'] = this.taxId;
    data['payment'] = this.payment;
    data['bank'] = this.bank;
    data['bank_branch'] = this.bankBranch;
    data['bank_id'] = this.bankId;
    data['company'] = this.company;
    data['department'] = this.department;
    data['section'] = this.section;
    data['position'] = this.position;
    data['img_url'] = this.imgUrl;
    return data;
  }
}