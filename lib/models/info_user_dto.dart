import 'dart:convert';

class InfoUserDTO {
  final String? id;
  final String? phoneNo;
  final String? fullname;
  final String? imgId;
  final String? carrierTypeId;
  final String? createdTime;

  DateTime get expiryAsDateTime => DateTime.parse(createdTime ?? '');

  factory InfoUserDTO.fromJson(Map<String, dynamic> json) {
    return InfoUserDTO(
      id: json['id'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      fullname: json['fullname'] ?? '',
      imgId: json['imgId'] ?? '',
      carrierTypeId: json['carrierTypeId'] ?? '',
      createdTime: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"id"'] = (id == '') ? '""' : '"$id"';
    data['"fullname"'] = (fullname == '') ? '""' : '"$fullname"';
    data['"phoneNo"'] = (phoneNo == '') ? '""' : '"$phoneNo"';
    data['"imgId"'] = (imgId == '') ? '""' : '"$imgId"';
    data['"carrierTypeId"'] = (carrierTypeId == '') ? '""' : '"$carrierTypeId"';
    data['"createdTime"'] = (createdTime == '') ? '""' : '"$createdTime"';
    return data;
  }

  InfoUserDTO({
    this.phoneNo,
    this.fullname,
    this.imgId,
    this.createdTime,
    this.id,
    this.carrierTypeId,
  });
}

class ListLoginAccountDTO {
  final List<InfoUserDTO> list;

  ListLoginAccountDTO({required this.list});

  factory ListLoginAccountDTO.fromJson(List? datas) {
    List<InfoUserDTO> list = [];
    if (datas == null || datas.isEmpty) {
      return ListLoginAccountDTO(list: list);
    }
    try {
      list = datas.map((f) => InfoUserDTO.fromJson(json.decode(f))).toList();
    } catch (e) {}
    return ListLoginAccountDTO(list: list);
  }
}
