
class CompanyModel {

  String? companyName;
  String? email;
  String? address;
  String? avatar;
  String? id;

  CompanyModel({
    this.companyName,
    this.email,
    this.address,
    this.avatar,
    this.id,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyName: json['companyName'],
      email: json['email'],
      address: json['address'],
      avatar: json['avatar'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'email': email,
      'address': address,
      'avatar': avatar,
      'id': id,
    };
  }

}