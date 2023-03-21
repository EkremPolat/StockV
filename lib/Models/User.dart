class User
{
    String email = "";
    String fullName = "";
    double currency = 1000.0;
    String id = "";

    User({required this.id, required this.email});

    String getEmail(){
        return email;
    }

    String getFullName(){
        return fullName;
    }

    void setFullName(String newName){
        fullName = newName;
    }

    double getCurrency(){
        return currency;
    }
}