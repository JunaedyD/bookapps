class UserData {
  final String id;
  String username;
  String email;
  String role;
  bool active;

  UserData({this.id, this.username, this.email, this.role, this.active});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        role: json['role'],
        active: json['active']);
  }
}
