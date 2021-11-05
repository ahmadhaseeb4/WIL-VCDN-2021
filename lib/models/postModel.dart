class PostModel {
  String _uid = "";
  String _username = "";
  String _pid = "";
  String _profilePicture = "";
  String _imageAddress = "";
  String _text = "";
  int _helpful = 0;
  List<String> _helpfuls = [];
  List<String> _comments = [];
  String _postedDate = "";

  PostModel({ required String uid, required String username, required String pid, required String profilePicture, required String imageAddress, required String text, required int helpful, required List<String> helpfuls, required List<String> comments, required String postedDate}) {
    this._uid = uid;
    this._username = username;
    this._pid = pid;
    this._profilePicture = profilePicture;
    this._imageAddress = imageAddress;
    this._text = text;
    this._helpful = helpful;
    this._helpfuls = helpfuls;
    this._comments = comments;
    this._postedDate = postedDate;
  }

  String get uid => _uid;
  set uid(String uid) => _uid = uid;
  String get username => _username;
  set username(String username) => _username = username;
  String get pid => _pid;
  set pid(String pid) => _pid = pid;
  String get profilePicture => _profilePicture;
  set profilePicture(String profilePicture) => _profilePicture = profilePicture;
  String get imageAddress => _imageAddress;
  set imageAddress(String imageAddress) => _imageAddress = imageAddress;
  String get text => _text;
  set text(String text) => _text = text;
  int get helpful => _helpful;
  set helpful(int helpful) => _helpful = helpful;
  List<String> get helpfuls => _helpfuls;
  set helpfuls(List<String> helpfuls) => _helpfuls = helpfuls;
  List<String> get comments => _comments;
  set comments(List<String> comments) => _comments = comments;
  String get postedDate => _postedDate;
  set postedDate(String postedDate) => _postedDate = postedDate;

  PostModel.fromJson(Map<String, dynamic> json) {
    _uid = json['uid'];
    _username = json['username'];
    _pid = json['pid'];
    _profilePicture = json['profilePicture'];
    _imageAddress = json['imageAddress'];
    _text = json['text'];
    _helpful = json['helpful'];
    _helpfuls = json['helpfuls'].cast<String>();
    _comments = json['comments'].cast<String>();
    _postedDate = json['postedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this._uid;
    data['username'] = this._username;
    data['pid'] = this._pid;
    data['profilePicture'] = this._profilePicture;
    data['imageAddress'] = this._imageAddress;
    data['text'] = this._text;
    data['helpful'] = this._helpful;
    data['helpfuls'] = this._helpfuls;
    data['comments'] = this._comments;
    data['postedDate'] = this._postedDate;
    return data;
  }
}