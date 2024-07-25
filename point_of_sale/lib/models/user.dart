class User {
  User({
    this.Id,
    this.UserName,
    this.Password,
    this.Name,
    this.BirthDay,
    this.Mobile,
    this.Email,
    this.Address,
    this.CreateBy,
    this.TypeAccount = "User",
    this.Status = true,
  });

  late int? Id;
  late String? UserName;
  late String? Password;
  late String? Name;
  late DateTime? BirthDay;
  late String? Mobile;
  late String? Email;
  late String? Address;
  late String? CreateBy;
  late String? TypeAccount;
  late bool? Status;

  User.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    UserName = json['userName'] ?? '';
    Password = json['password'] ?? '';
    Name = json['name'] ?? '';
    BirthDay =  json['birthDay'] != null ? DateTime.tryParse(json['birthDay'].toString()) : null;
    Mobile = json['mobile'] ?? '';
    Email = json['email'] ?? '';
    Address = json['address'] ?? '';
    CreateBy = json['createBy'] ?? '';
    TypeAccount = json['typeAccount'] ?? '';
    Status = json['status'];
  }

  Map<String, dynamic> toJson() => {
    'id': Id,
    'userName': UserName,
    'password': Password,
    'name': Name,
    'birthDay': BirthDay!.toIso8601String(),
    'mobile': Mobile,
    'email': Email,
    'address': Address,
    'createBy': CreateBy,
    'typeAccount': TypeAccount,
    'status': Status,
  };
}
