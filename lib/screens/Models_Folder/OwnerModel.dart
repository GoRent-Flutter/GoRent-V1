class OwnerModel {
  String? ownerId;
  String? fullname;
  String? password;
  String? email;
  String? city;
  String? phone_number;
  //phone number is string because when fetching the data (strings will be fetched)
  OwnerModel({
    this.fullname,
    this.email,
    this.password,
    this.city,
    this.ownerId,
    this.phone_number,
  });
  OwnerModel.fromMap(Map<String, dynamic> map) {
    ownerId = map["ownerId"];
    fullname = map["fullname"];
    email = map["email"];
    password = map["password"];
    city = map["city"];
    phone_number = map["phone_number"];
  }
  Map<String, dynamic> toMap() {
    return {
      "ownerId": ownerId,
      "fullname": fullname,
      "email": email,
      "password": password,
      "city": city,
      "phone_number": phone_number
    };
  }
}
