class userApi {
  String? id;
  String? name;
  String? postion;
  String? tel;
  String? email;
  String? username;
  String? password;

  userApi(
      {this.id,
        this.name,
        this.postion,
        this.tel,
        this.email,
        this.username,
        this.password});

  userApi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    postion = json['postion'];
    tel = json['tel'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['postion'] = this.postion;
    data['tel'] = this.tel;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}