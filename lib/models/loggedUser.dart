// ignore: file_names
class LoggedUser{
  static final LoggedUser _loggedUser = LoggedUser._internal();
  String _openedChat='';
  String _fullName = '';
  String _gender = '';
  String _phoneNumber = '';
  String _email = '';
  String _id = '';
  List<String> _blockedUsersIds = [];
  bool _isLogged = false;


  factory LoggedUser(){
    return _loggedUser;
  }



  //call this method to set the attributes of the logged user
  //this method is only be called once
  void setAttributes(String fullName, String gender, String phoneNumber, String email, String id, List<String> blockedUsersIds){
    if(_isLogged) {
      print('LoggedUser attributes are already set');
      return;
    }
    
    _isLogged = true;
    _fullName = fullName;
    _gender = gender;
    _phoneNumber = phoneNumber;
    _email = email;
    _id = id;
    _blockedUsersIds = blockedUsersIds;
    print('LoggedUser attributes are set');
  }

  void logOut(){
    _isLogged = false;
    _fullName = '';
    _email = '';
    _gender = '';
    _phoneNumber = '';
    _id = '';
    _blockedUsersIds = [];
  }

  // add getters for the attributes
  String get fullName => _fullName;
  String get gender => _gender;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get id => _id;
  String get openedChat => _openedChat;
  List<String> get blockedUsersIds => _blockedUsersIds;

  // setter of openedChat

  set openedChat(String value) {
    _openedChat = value;
  }

  LoggedUser._internal();
}

// to get Logged User instance
// LoggedUser loggedUser = LoggedUser();