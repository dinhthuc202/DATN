import 'package:intl/intl.dart';

class Sale {
  Sale({
    this.Id,
    this.Date,
    this.IsReturn = false,
    this.CustomerId,
    this.EmployeeId,
    this.SaleQty,
    this.SaleAmount,
    this.SaleReturnQty,
    this.SaleReturnAmount,
    this.PaymentMethod,
    this.PaymentDetail,
    this.Remarks,
    this.saleDetails,
    this.EmployeeName,
    this.CustomerName,
  });

  late int? Id;
  late DateTime? Date;
  late bool? IsReturn;
  late int? CustomerId;
  late String? CustomerName;
  late int? EmployeeId;
  late String? EmployeeName;
  late int? SaleQty;
  late double? SaleAmount;
  late int? SaleReturnQty;
  late double? SaleReturnAmount;
  late String? PaymentMethod;
  late String? PaymentDetail;
  late String? Remarks;
  late List<SaleDetails>? saleDetails;

  Sale.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    Date = json['date'] != null
        ? DateTime.tryParse(json['date'].toString())
        : null;
    IsReturn = json['isReturn'];
    CustomerId = json['customerId'];
    EmployeeId = json['employeeId'];
    SaleQty = json['saleQty'];
    SaleAmount = json['saleAmount'];
    SaleReturnQty = json['saleReturnQty'];
    SaleReturnAmount = json['saleReturnAmount'];
    PaymentMethod = json['paymentMethod'];
    PaymentDetail = json['paymentDetail'];
    Remarks = json['remarks'];
    saleDetails = json['saleDetails'] != null
        ? List.from(json['saleDetails'])
            .map((e) => SaleDetails.fromJson(e))
            .toList()
        : null;
    CustomerName = json['customerName'] ?? '';
    EmployeeName = json['employeeName'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'date': Date?.toIso8601String(),
        'isReturn': IsReturn,
        'customerId': CustomerId,
        'employeeId': EmployeeId,
        'saleQty': SaleQty,
        'saleAmount': SaleAmount,
        'saleReturnQty': SaleReturnQty,
        'saleReturnAmount': SaleReturnAmount,
        'paymentMethod': PaymentMethod,
        'paymentDetail': PaymentDetail,
        'remarks': Remarks,
        'saleDetails': saleDetails!.map((e) => e.toJson()).toList(),
      };
}

class SaleDetails {
  SaleDetails({
    this.Id,
    this.SaleId,
    this.ItemId,
    this.ItemName = '',
    this.Quantity,
    this.Price,
    this.BatchNo,
    this.Unit,
  });

  late int? Id;
  late int? SaleId;
  late int? ItemId;
  late String? ItemName;
  late int? Quantity;
  late double? Price;
  late String? BatchNo;
  late String? Unit;

  SaleDetails.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    SaleId = json['saleId'];
    ItemId = json['itemId'];
    Quantity = json['quantity'];
    Price = json['price'];
    BatchNo = json['batchNo'];
    ItemName = json['itemName'];
  }

  Map<String, dynamic> toJson() => {
        'id': Id,
        'saleId': SaleId,
        'itemId': ItemId,
        'quantity': Quantity,
        'price': Price,
        'batchNo': BatchNo,
      };
}

class SaleData {
  SaleData({
    required this.saleDate,
    required this.totalQuantitySold,
  });
  late final DateTime  saleDate;
  late final int totalQuantitySold;

  SaleData.fromJson(Map<String, dynamic> json){
    saleDate = DateTime.parse(json['saleDate']);
    totalQuantitySold = json['totalQuantitySold'] ??"";
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(saleDate);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['saleDate'] = saleDate;
    _data['totalQuantitySold'] = totalQuantitySold;
    return _data;
  }
}
