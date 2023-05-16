class SkillModel {
  String? ka;
  late List<String> otherskill;

  SkillModel(this.otherskill,this.ka);

  SkillModel.fromJson(Map<String, dynamic> json) {
    otherskill = json['otherskill'].cast<String>();
    ka = json['ka'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherskill'] = this.otherskill;
    data['ka'] = this.ka;
    return data;
  }
}