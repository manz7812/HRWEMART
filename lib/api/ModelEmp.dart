class EmpModel {
  late List<String> empName;

  EmpModel(this.empName);

  EmpModel.fromJson(Map<String, dynamic> json) {
    empName = json['emp_name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_name'] = this.empName;
    return data;
  }
}