class Item {
  Item({
    this.Id,
    this.Name,
    this.PurchasePrice,
    this.SalePrice,
    this.Stock,
    this.UnitId,
    this.unitDetails,
    this.GroupId,
    this.groupDetails,
    this.BarCode,
    this.CreateDate,
    this.UpdateDate,
    this.Description,
    this.Image,
  });

  late int? Id;
  late String? Name;
  late double? PurchasePrice;
  late double? SalePrice;
  late int? Stock;
  late int? UnitId;
  late UnitDetails? unitDetails;
  late int? GroupId;
  late GroupDetails? groupDetails;
  late String? BarCode;
  late DateTime? CreateDate;
  late DateTime? UpdateDate;
  late String? Description;
  late String? Image;

  Item.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    Name = json['name'] ?? '';
    PurchasePrice = json['purchasePrice'];
    SalePrice = json['salePrice'];
    Stock = json['stock'];
    UnitId = json['unitId'];
    unitDetails = json['unitDetails'] != null
        ? UnitDetails.fromJson(json['unitDetails'])
        : null;
    GroupId = json['groupId'];
    groupDetails = json['groupDetails'] != null
        ? GroupDetails.fromJson(json['groupDetails'])
        : null;
    BarCode = json['barCode'] ?? '';
    CreateDate = json['createDate'] != null
        ? DateTime.tryParse(json['CreateDate'].toString())
        : null;
    UpdateDate = json['updateDate'] != null
        ? DateTime.tryParse(json['UpdateDate'].toString())
        : null;
    Description = json['description'] ?? '';
    Image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'name': Name,
        'purchasePrice': PurchasePrice,
        'salePrice': SalePrice,
        'stock': Stock,
        'unitId': UnitId,
        //data['unitDetails'] = unitDetails!.toJson();
        'groupId': GroupId,
        //data['groupDetails'] = groupDetails!.toJson();
        'barCode': BarCode,
        'createDate': CreateDate,
        'updateDate': UpdateDate,
        'description': Description,
        'image': Image,
      };
}

class UnitDetails {
  UnitDetails({
    this.Id,
    this.UnitName,
    this.Description,
  });

  late int? Id;
  late String? UnitName;
  late String? Description;

  UnitDetails.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    UnitName = json['unitName'] ?? '';
    Description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() =>{
    'id' : Id,
    'unitName' : UnitName,
    'description' : Description,
  };
}

class GroupDetails {
  GroupDetails({
    this.Id,
    this.GroupName,
    this.Description,
  });

  late int? Id;
  late String? GroupName;
  late String? Description;

  GroupDetails.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    GroupName = json['groupName'] ?? '';
    Description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() => {
    'id' : Id,
    'groupName' : GroupName,
    'description' : Description,
  };
}
