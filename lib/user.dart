class user {
  int id;
  int roleId;
  String email;
  String lastLogin;
  bool loggedIn;

  user({
    this.id,
    this.roleId,
    this.email,
    this.lastLogin,
    this.loggedIn,
  });

  factory user.fromJson(Map<String, dynamic> json) {
    if(json['id'] == null){
      return user(
        id: 0,
//      roleId: int.tryParse(json['role_id']),
        email: json['email'],
//      lastLogin: json['last_login'],
        loggedIn: false,
      );


    }
    else {
      return user(
        id: int.tryParse(json['id']),
//      roleId: int.tryParse(json['role_id']),
        email: json['email'],
//      lastLogin: json['last_login'],
        loggedIn: false,
      );
    }
  }
}