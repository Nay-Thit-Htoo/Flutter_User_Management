import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.isAdmin,
    this.insertedDate,
    this.role,
  });

  String? id;
  String? name;
  String? email;
  String? password;
  bool? isAdmin;
  String? insertedDate;
  Role? role;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        isAdmin: json["isAdmin"],
        insertedDate: json["insertedDate"].toString(),
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "isAdmin": isAdmin,
        "insertedDate": insertedDate.toString(),
        "role": role?.toJson(),
      };
}

class Role {
  Role({
    this.id,
    this.roleType,
    this.insertedDate,
    this.v,
  });

  String? id;
  String? roleType;
  String? insertedDate;
  int? v;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["_id"],
        roleType: json["roleType"],
        insertedDate: json["insertedDate"].toString(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "roleType": roleType,
        "insertedDate": insertedDate.toString(),
        "__v": v,
      };
}

List<User> userListFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userListToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
