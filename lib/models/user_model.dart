class UserModel {
  UserModel({
    required this.token,
  });

  String token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
