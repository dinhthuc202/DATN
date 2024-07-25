class Purchase {
  Purchase({
    this.Id,
    this.Date,
    this.IsReturn = false,
    this.SupplierId,
    this.SupplierName,
    this.EmployeeId,
    this.EmployeeName,
    this.PurchaseQty,
    this.PurchaseAmount,
    this.PurchaseReturnQty,
    this.PurchaseReturnAmount,
    this.PaymentMethod,
    this.PaymentDetails,
    this.Remarks,
    this.purchaseDetails,
  });

  late int? Id;
  late DateTime? Date;
  late bool? IsReturn;
  late int? SupplierId;
  late String? SupplierName;
  late int? EmployeeId;
  late String? EmployeeName;
  late int? PurchaseQty;
  late double? PurchaseAmount;
  late int? PurchaseReturnQty;
  late double? PurchaseReturnAmount;
  late String? PaymentMethod;
  late String? PaymentDetails;
  late String? Remarks;
  late List<PurchaseDetails>? purchaseDetails;

  Purchase.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    Date = json['date'] != null
        ? DateTime.tryParse(json['date'].toString())
        : null;
    IsReturn = json['isReturn'];
    SupplierId = json['supplierId'];
    EmployeeId = json['employeeId'];
    PurchaseQty = json['purchaseQty'];
    PurchaseAmount = json['purchaseAmount'];
    PurchaseReturnQty = json['purchaseReturnQty'];
    PurchaseReturnAmount = json['purchaseReturnAmount'];
    PaymentMethod = json['paymentMethod'] ?? '';
    PaymentDetails = json['paymentDetails'] ?? '';
    Remarks = json['remarks'] ?? '';
    purchaseDetails = json['purchaseDetails'] != null
        ? List.from(json['purchaseDetails'])
            .map((e) => PurchaseDetails.fromJson(e))
            .toList()
        : null;
    SupplierName = json['supplierName'];
    EmployeeName = json['employeeName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = Id;
    data['date'] = Date;
    data['isReturn'] = IsReturn;
    data['supplierId'] = SupplierId;
    data['employeeId'] = EmployeeId;
    data['purchaseQty'] = PurchaseQty;
    data['purchaseAmount'] = PurchaseAmount;
    data['purchaseReturnQty'] = PurchaseReturnQty;
    data['purchaseReturnAmount'] = PurchaseReturnAmount;
    data['paymentMethod'] = PaymentMethod;
    data['paymentDetails'] = PaymentDetails;
    data['remarks'] = Remarks;
    data['purchaseDetails'] = purchaseDetails!.map((e) => e.toJson()).toList();
    return data;
  }
}

class PurchaseDetails {
  PurchaseDetails({
    this.Id,
    this.PurchaseId,
    this.ItemId,
    this.Quantity,
    this.Price,
    this.BatchNo,
    this.ItemName = '',
  });

  late int? Id;
  late int? PurchaseId;
  late int? ItemId;
  late int? Quantity;
  late double? Price;
  late String? BatchNo;
  late String? ItemName;
  late String? Unit;



  PurchaseDetails.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    PurchaseId = json['purchaseId'];
    ItemId = json['itemId'];
    Quantity = json['quantity'];
    Price = json['price'];
    BatchNo = json['batchNo'] ?? '';
    ItemName = json['itemName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = Id;
    data['purchaseId'] = PurchaseId;
    data['itemId'] = ItemId;
    data['quantity'] = Quantity;
    data['price'] = Price;
    data['batchNo'] = BatchNo;
    return data;
  }
}
