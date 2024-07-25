class Customer {
  Customer({
    this.Id,
    this.Name,
    this.Address,
    this.Birthday,
    this.Email,
    this.Phone,
    this.Description,
  });

  late int? Id;
  late String? Name;
  late String? Address;
  late DateTime? Birthday;
  late String? Email;
  late String? Phone;
  late String? Description;

  Customer.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    Name = json['name'] ?? '';
    Address = json['address'] ?? '';
    Birthday = json['birthday'] != null
        ? DateTime.tryParse(json['birthday'].toString())
        : null;
    Email = json['email'] ?? '';
    Phone = json['phone'] ?? '';
    Description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'name': Name,
        'address': Address,
        'birthday': Birthday!.toIso8601String(),
        'email': Email,
        'phone': Phone,
        'description': Description
      };
}
