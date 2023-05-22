class User {
  String email = "";
  String fullName = "";
  double balance = 1000.0;
  String id = "";
  bool isLoggedIn = false;


  User({required this.id, required this.email, required this.fullName, this.isLoggedIn = false,});

  String getEmail() {
    return email;
  }

  String getFullName() {
    return fullName;
  }

  void setFullName(String newName) {
    fullName = newName;
  }

  double getCurrency() {
    return balance;
  }

  String getId() {
    return id;
  }
  void setLoggedIn(bool value) {
    isLoggedIn = value;
  }

  bool isUserLoggedIn() {
    return isLoggedIn;
  }
}
