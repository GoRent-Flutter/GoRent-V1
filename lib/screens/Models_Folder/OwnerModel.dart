class OwnerModel{
String? ownerId;
String? ownername;
String? email;
String? city;
OwnerModel({this.ownername, this.email, this.city, required userId});
OwnerModel.fromMap(Map<String, dynamic> map){
  ownerId=map["userId"];
  ownername=map["username"];
  email=map["email"];
  city=map["city"];
}
Map<String,dynamic> toMap(){
  return{
"ownerId":ownerId,
"ownername":ownername,
"email":email,
"city":city,
  };
}
  
}