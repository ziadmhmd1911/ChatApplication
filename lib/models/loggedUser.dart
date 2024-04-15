// ignore: file_names
class LoggedUser{
  static final LoggedUser _loggedUser = LoggedUser._internal();
  String _fullName = '';
  String _gender = '';
  String _phoneNumber = '';
  String _email = '';
  String _id = '';
  bool _isLogged = false;


  factory LoggedUser(){
    return _loggedUser;
  }

  //call this method to set the attributes of the logged user
  //this method is only be called once
  void setAttributes(String fullName, String gender, String phoneNumber, String email, String id){
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
  }

  // add getters for the attributes
  String get fullName => _fullName;
  String get gender => _gender;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get id => _id;

  LoggedUser._internal();
}

// to get Logged User instance
// LoggedUser loggedUser = LoggedUser();