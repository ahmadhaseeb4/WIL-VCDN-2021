class UserModel {
  String _uid = "";
  bool _admin = false;

  UserModel({required String uid, required bool admin}) {
    this._uid = uid;
    this._admin = admin;
  }

  String get uid => _uid;
  set uid(String uid) => _uid = uid;
  bool get admin => _admin;
  set admin(bool admin) => _admin = admin;

  UserModel.fromJson(Map<String, dynamic> json) {
    _uid = json['uid'];
    _admin = json['admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this._uid;
    data['admin'] = this._admin;
    return data;
  }
}