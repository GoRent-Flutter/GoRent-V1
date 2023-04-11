class UserModel{
String? userId;
String? username;
String? email;
String? city;
UserModel({this.username, this.email, this.city, required userId});
UserModel.fromMap(Map<String, dynamic> map){
  userId=map["userId"];
  username=map["username"];
  email=map["email"];
  city=map["city"];
}
Map<String,dynamic> toMap(){
  return{
"userId":userId,
"username":username,
"email":email,
"city":city,
  };
}
}