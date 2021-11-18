class UserModel {
  String _uid = "";
  bool _admin = false;
  String _contact = "";

  UserModel({required String uid, required bool admin, required String contact}) {
    this._uid = uid;
    this._admin = admin;
    this._contact = contact;
  }

  String get uid => _uid;
  set uid(String uid) => _uid = uid;
  bool get admin => _admin;
  set admin(bool admin) => _admin = admin;
  String get contact => _contact;
  set contact(String contact) => _contact = contact;

  UserModel.fromJson(Map<String, dynamic> json) {
    _uid = json['uid'];
    _admin = json['admin'];
    _contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this._uid;
    data['admin'] = this._admin;
    data['contact'] = this._contact;
    return data;
  }
}