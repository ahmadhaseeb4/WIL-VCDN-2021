class CommentModel {
  String _commentDate = "";
  int _commentNo = 0;
  String _text = "";
  String _userID = "";
  String _username = "";

  CommentModel({
    required String commentDate,
    required int commentNo,
    required String text,
    required String userID,
    required String username}) {
    this._commentDate = commentDate;
    this._commentNo = commentNo;
    this._text = text;
    this._userID = userID;
    this._username = username;
  }

  String get commentDate => _commentDate;
  set commentDate(String commentDate) => _commentDate = commentDate;
  int get commentNo => _commentNo;
  set commentNo(int commentNo) => _commentNo = commentNo;
  String get text => _text;
  set text(String text) => _text = text;
  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get username => _username;
  set username(String username) => _username = username;

  CommentModel.fromJson(Map<String, dynamic> json) {
    _commentDate = json['commentDate'];
    _commentNo = json['commentNo'];
    _text = json['text'];
    _userID = json['userID'];
    _username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentDate'] = this._commentDate;
    data['commentNo'] = this._commentNo;
    data['text'] = this._text;
    data['userID'] = this._userID;
    data['username'] = this._username;
    return data;
  }
}