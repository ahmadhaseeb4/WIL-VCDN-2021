class UserModel {
  String _uid = "";
  String _name = "";
  String _pic = "";
  String _contact = "";
  bool _admin = false;

  UserModel({required String uid, required String name, required String pic, required String contact, required bool admin}) {
    this._uid = uid;
    this._name = name;
    this._pic = pic;
    this._contact = contact;
    this._admin = admin;
  }

  String get uid => _uid;
  set uid(String uid) => _uid = uid;
  String get name => _name;
  set name(String name) => _name = name;
  String get pic => _pic;
  set pic(String pic) => _pic = pic;
  String get contact => _contact;
  set contact(String contact) => _contact = contact;
  bool get admin => _admin;
  set admin(bool admin) => _admin = admin;

  UserModel.fromJson(Map<String, dynamic> json) {
    _uid = json['uid'];
    _name = json['name'];
    _pic = json['pic'];
    _contact = json['contact'];
    _admin = json['admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this._uid;
    data['name'] = this._name;
    data['pic'] = this._pic;
    data['contact'] = this._contact;
    data['admin'] = this._admin;
    return data;
  }
}