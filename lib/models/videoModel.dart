class VideoModel {
  String _id = "";
  String _userID = "";
  String _videoTitle = "";
  String _videoDescription = "";
  String _link = "";
  String _date = "";

  VideoModel({required String id, required String userID, required String videoTitle, required String videoDescription, required String link, required String date}) {
    this._id = id;
    this._userID = userID;
    this._videoTitle = videoTitle;
    this._videoDescription = videoDescription;
    this._link = link;
    this._date = date;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get videoTitle => _videoTitle;
  set videoTitle(String videoTitle) => _videoTitle = videoTitle;
  String get videoDescription => _videoDescription;
  set videoDescription(String videoDescription) =>
      _videoDescription = videoDescription;
  String get link => _link;
  set link(String link) => _link = link;
  String get date => _date;
  set date(String date) => _date = date;

  VideoModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userID = json['userID'];
    _videoTitle = json['videoTitle'];
    _videoDescription = json['videoDescription'];
    _link = json['link'];
    _date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['userID'] = this._userID;
    data['videoTitle'] = this._videoTitle;
    data['videoDescription'] = this._videoDescription;
    data['link'] = this._link;
    data['date'] = this._date;
    return data;
  }
}