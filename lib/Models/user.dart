class User {
  String _email = "";
  String _fullName = "";
  final double _currency = 1000.0;

  User(String email, String fullName) {
    _email = email;
    _fullName = fullName;
  }

  String getEmail() {
    return _email;
  }

  String getFullName() {
    return _fullName;
  }

  void setFullName(String newName) {
    _fullName = newName;
  }

  double getCurrency() {
    return _currency;
  }
}
