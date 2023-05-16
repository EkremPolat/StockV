class User {
  String email = "";
  String fullName = "";
  double balance = 1000.0;
  String id = "";

  User({required this.id, required this.email, required this.fullName});

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
  
}
