class CustModel {
  String? custId;
  String? fullname;
  String? password;
  String? email;
  String? city;
  String? phone_number;
  //phone number is string because when fetching the data (strings will be fetched)
  CustModel({
    this.fullname,
    this.email,
    this.password,
    this.city,
    this.custId,
    this.phone_number,
  });
  CustModel.fromMap(Map<String, dynamic> map) {
    custId = map["custId"];
    fullname = map["fullname"];
    email = map["email"];
    password = map["password"];
    city = map["city"];
    phone_number = map["phone_number"];
  }
  Map<String, dynamic> toMap() {
    return {
      "custId": custId,
      "fullname": fullname,
      "email": email,
      "password": password,
      "city": city,
      "phone_number": phone_number
    };
  }
}
