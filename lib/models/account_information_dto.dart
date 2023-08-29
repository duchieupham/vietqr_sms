class AccountInformationDTO {
  final String smsId;
  final String phoneNo;
  final String fullName;
  final String email;
  final String imgId;
  final String carrierTypeId;

  const AccountInformationDTO({
    required this.smsId,
    required this.phoneNo,
    required this.fullName,
    required this.email,
    required this.imgId,
    this.carrierTypeId = '',
  });

  factory AccountInformationDTO.fromJson(Map<String, dynamic> json) {
    return AccountInformationDTO(
      smsId: json['smsId'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      imgId: json['imgId'] ?? '',
      carrierTypeId: json['carrierTypeId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = smsId;
    data['phoneNo'] = phoneNo;
    data['fullName'] = fullName;
    data['email'] = email;
    data['imgId'] = imgId;
    data['carrierTypeId'] = carrierTypeId;
    return data;
  }

  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"userId"'] = (smsId == '') ? '""' : '"$smsId"';
    data['"phoneNo"'] = (phoneNo == '') ? '""' : '"$phoneNo"';
    data['"fullName"'] = (fullName == '') ? '""' : '"$fullName"';
    data['"email"'] = (email == '') ? '""' : '"$email"';
    data['"imgId"'] = (imgId == '') ? '""' : '"$imgId"';
    data['"carrierTypeId"'] = (carrierTypeId == '') ? '""' : '"$carrierTypeId"';
    return data;
  }
}
