//this will be used to fetch both owner/customer data
class UserModel {
  String? id;
  String? fullname;
  String? password;
  String? email;
  String? city;
  String? phoneNumber;
  String? type;

  UserModel({
    this.fullname,
    this.email,
    this.password,
    this.city,
    this.id,
    this.phoneNumber,
    this.type,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map['type'] == 'GRCU') {
      return UserModel(
        id: map['custId'],
        fullname: map['fullname'],
        email: map['email'],
        password: map['password'],
        city: map['city'],
        phoneNumber: map['phone_number'],
        type: map['type'],
      );
    } else {
      return UserModel(
        id: map['ownerId'],
        fullname: map['fullname'],
        email: map['email'],
        password: map['password'],
        city: map['city'],
        phoneNumber: map['phone_number'],
        type: map['type'],
      );
    }
  }

  Map<String, dynamic> toMap() {
    if (type == 'GRCU') {
      return {
        'custId': id,
        'fullname': fullname,
        'email': email,
        'password': password,
        'city': city,
        'phone_number': phoneNumber,
        'type': type,
      };
    } else {
      return {
        'ownerId': id,
        'fullname': fullname,
        'email': email,
        'password': password,
        'city': city,
        'phone_number': phoneNumber,
        'type': type,
      };
    }
  }
}
