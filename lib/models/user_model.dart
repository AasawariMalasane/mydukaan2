
import 'dart:convert';

List<UserModel> UserModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String UserModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
     this.userId,
     this.avatar,
     this.firstName,
     this.lastName,
     this.phoneNumber,
     this.email,
     this.authenticationToken
  });

  var userId;
  var avatar;
  var firstName;
  var lastName;
  var phoneNumber;
  var email;
  var authenticationToken;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userId"],
    avatar: json["avatar"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    authenticationToken: json["authenticationToken"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "avatar": avatar,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "email": email,
    "authenticationToken":authenticationToken
  };
}
