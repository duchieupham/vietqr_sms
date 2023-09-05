class AccountLoginDTO {
  final String phoneNo;
  final String password;
  final String? fullName;
  final String? email;

  final String? device;
  final String? fcmToken;
  final String? userIp;

  const AccountLoginDTO({
    required this.phoneNo,
    required this.password,
    this.fullName,
    this.email,
    this.device,
    this.fcmToken,
    this.userIp,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    if (fullName != null) data['fullName'] = fullName;
    if (fcmToken != null) data['fcmToken'] = fcmToken;
    if (email != null) data['email'] = email;
    if (device != null) data['device'] = device;
    if (userIp != null) data['userIp'] = userIp;
    return data;
  }
}
