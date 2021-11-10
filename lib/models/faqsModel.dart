class FAQsModel {
  String _id = "";
  String _userID = "";
  String _question = "";
  String _answer = "";
  int _helpful = 0;
  int _notHelpful = 0;

  FAQsModel({required String id, required String userID, required String question, required String answer, required int helpful, required int notHelpful}) {
    this._id = id;
    this._userID = userID;
    this._question = question;
    this._answer = answer;
    this._helpful = helpful;
    this._notHelpful = notHelpful;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get userID => _userID;
  set userID(String userID) => _userID = userID;
  String get question => _question;
  set question(String question) => _question = question;
  String get answer => _answer;
  set answer(String answer) => _answer = answer;
  int get helpful => _helpful;
  set helpful(int helpful) => _helpful = helpful;
  int get notHelpful => _notHelpful;
  set notHelpful(int notHelpful) => _notHelpful = notHelpful;

  FAQsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userID = json['userID'];
    _question = json['question'];
    _answer = json['answer'];
    _helpful = json['helpful'];
    _notHelpful = json['not_helpful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['userID'] = this._userID;
    data['question'] = this._question;
    data['answer'] = this._answer;
    data['helpful'] = this._helpful;
    data['not_helpful'] = this._notHelpful;
    return data;
  }
}