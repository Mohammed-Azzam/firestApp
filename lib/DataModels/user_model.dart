class UserModel {
  // {
  // "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvc3BlZWRhbmRzdWNjZXNzcGhvbmUud2Vic2l0ZVwvZHJhZnRcL29sZCIsImlhdCI6MTYyODU0OTA2MSwibmJmIjoxNjI4NTQ5MDYxLCJleHAiOjE2MjkxNTM4NjEsImRhdGEiOnsidXNlciI6eyJpZCI6IjM2MjkifX19.hQ-VGJ9pmI0txFTYsELGcOd7LnlENkOEG_vim9vFG-A",
  // "user_email": "",
  // "user_nicename": "flutter-developer",
  // "user_display_name": "flutter developer"
  // }

  late final String token;
  late final String user_email;
  late final String user_nicename;
  late final String user_display_name;

  UserModel({
    required this.token,
    required this.user_email,
    required this.user_nicename,
    required this.user_display_name,
  });

  UserModel.fromJson(json) {
    this.token = json['token'];
    this.user_email = json['user_email'];
    this.user_nicename = json['user_nicename'];
    this.user_display_name = json['user_display_name'];
  }

  Map<String, dynamic> toMap() {
    return {
      "token": token,
      "user_email": user_email,
      "user_nicename": user_nicename,
      "user_display_name": user_display_name
    };
  }
}
