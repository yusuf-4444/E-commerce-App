// ignore_for_file: public_member_api_docs, sort_constructors_first

class UsersDataModel {
  final String id;
  final String userName;
  final String email;
  final String createdAt;

  UsersDataModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory UsersDataModel.fromMap(Map<String, dynamic> map) {
    return UsersDataModel(
      id: map['id'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
