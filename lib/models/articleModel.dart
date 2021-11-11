class ArticleModel {
  String _id = "";
  String _userID = "";
  String _articleTitle = "";
  String _articleDescription = "";
  String _link = "";
  String _date = "";

  ArticleModel({required String id, required String userID, required String articleTitle, required String articleDescription, required String link, required String date}) {
    this._id = id;
    this._userID = userID;
    this._articleTitle = articleTitle;
    this._articleDescription = articleDescription;
    this._link = link;
    this._date = date;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get articleTitle => _articleTitle;
  set articleTitle(String articleTitle) => _articleTitle = articleTitle;
  String get articleDescription => _articleDescription;
  set articleDescription(String articleDescription) =>
      _articleDescription = articleDescription;
  String get link => _link;
  set link(String link) => _link = link;
  String get date => _date;
  set date(String date) => _date = date;

  ArticleModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userID = json['userID'];
    _articleTitle = json['articleTitle'];
    _articleDescription = json['articleDescription'];
    _link = json['link'];
    _date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['userID'] = this._userID;
    data['articleTitle'] = this._articleTitle;
    data['articleDescription'] = this._articleDescription;
    data['link'] = this._link;
    data['date'] = this._date;
    return data;
  }
}