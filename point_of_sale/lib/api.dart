import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/customer.dart';
import 'models/item.dart';
import 'models/purchase.dart';
import 'models/sale.dart';
import 'models/supplier.dart';
import 'models/user.dart';

String urlApi = "https://localhost:7214";
//String urlApi = "http://localhost:90";
//String urlApi = "http://192.168.10.208:90";

class Api {
  ///User
  static Future<bool?> register({required User user}) async {
    try {
      final response = await http.post(
        Uri.parse("$urlApi/api/Register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 409) {
        return null;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to send data');
    }
  }

  static Future<bool> updateUser({required User user}) async {
    try {
      final response = await http.put(
        Uri.parse("$urlApi/api/UpdateUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to update data');
    }
  }

  static Future<bool> deleteUser({required int userId}) async {
    try {
      String url = "$urlApi/api/User?id=$userId";
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed');
    }
  }

  static Future<List<User>> getUsers(
      String? filter, String? typeAccount) async {
    try {
      final Uri uri = Uri.parse("$urlApi/api/GetUsers").replace(
        queryParameters: {
          if (filter != null) 'filter': filter,
          if (typeAccount != null) 'typeAccount': typeAccount,
        },
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<User> users = data.map((e) => User.fromJson(e)).toList();
        return users;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<User> getUser({required int userId}) async {
    try {
      String url = "$urlApi/api/GetUser/$userId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final User user = User.fromJson(data);
        return user;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  ///Item
  static Future<Map<String, dynamic>> getItems({
    String? filter = '',
    int? pageNumber = 1,
    int? pageSize = 20,
    bool? inStock = false,
    int? groupId,
    bool? sortByNewest = false,
  }) async {
    try {
      String url =
          "$urlApi/api/Item?pageNumber=$pageNumber&pageSize=$pageSize&filter=$filter&inStock=$inStock";
      if (groupId != null) {
        url += "&groupId=$groupId";
      }
      url += "&sortByNewest=$sortByNewest";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final int totalPages = json.decode(response.body)['totalPage'];
        final List<dynamic> data = json.decode(response.body)['items'];
        final List<Item> items = data.map((e) => Item.fromJson(e)).toList();
        return {'items': items, 'totalPage': totalPages};
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<Item> getItem({required int itemId}) async {
    try {
      String url = "$urlApi/api/Item/$itemId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Item item = Item.fromJson(data);
        return item;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<Item> getItemByBarcode({required String barcode}) async {
    try {
      String url = "$urlApi/api/Item/barcode/$barcode";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Item item = Item.fromJson(data);
        return item;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> addItem({required Item item}) async {
    try {
      final response = await http.post(
        Uri.parse("$urlApi/api/Item"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to send data');
    }
  }

  static Future<bool> updateItem({required Item item}) async {
    try {
      final response = await http.put(
        Uri.parse("$urlApi/api/Item"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to update data');
    }
  }

  static Future<bool> deleteItem({required int itemId}) async {
    try {
      String url = "$urlApi/api/Item/$itemId";
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed');
    }
  }

  static Future<List<GroupDetails>> getGroups() async {
    try {
      String url = "$urlApi/api/Item/ItemGroup";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<GroupDetails> groups =
            data.map((e) => GroupDetails.fromJson(e)).toList();
        return groups;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<UnitDetails>> getUnits() async {
    try {
      String url = "$urlApi/api/Item/Unit";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<UnitDetails> units =
            data.map((e) => UnitDetails.fromJson(e)).toList();
        return units;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  ///Customer
  static Future<Customer> getCustomer({required int customerId}) async {
    try {
      String url = "$urlApi/api/Customer/$customerId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Customer customer = Customer.fromJson(data);
        return customer;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> getCustomers({
    String? filter,
    int? pageNumber = 1,
    int? pageSize = 20,
  }) async {
    try {
      String url =
          "$urlApi/api/Customer?pageNumber=$pageNumber&pageSize=$pageSize&filter=$filter";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final int totalPages = json.decode(response.body)['totalPage'];
        final List<dynamic> data = json.decode(response.body)['customers'];
        final List<Customer> customers =
            data.map((e) => Customer.fromJson(e)).toList();
        return {'customers': customers, 'totalPage': totalPages};
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> addCustomer({required Customer customer}) async {
    try {
      final response = await http.post(
        Uri.parse("$urlApi/api/Customer"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(customer.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to send data');
    }
  }

  static Future<bool> updateCustomer({required Customer customer}) async {
    try {
      final response = await http.put(
        Uri.parse("$urlApi/api/Customer"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to update data');
    }
  }

  static Future<bool> deleteCustomer({required int customerId}) async {
    try {
      String url = "$urlApi/api/Customer/?id=$customerId";
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed');
    }
  }

  ///Supplier
  static Future<Supplier> getSupplier({required int supplierId}) async {
    try {
      String url = "$urlApi/api/Supplier/$supplierId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Supplier supplier = Supplier.fromJson(data);
        return supplier;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> getSuppliers({
    String? filter = '',
    int? pageNumber = 1,
    int? pageSize = 20,
  }) async {
    try {
      String url =
          "$urlApi/api/Supplier?pageNumber=$pageNumber&pageSize=$pageSize&filter=$filter";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final int totalPages = json.decode(response.body)['totalPage'];
        final List<dynamic> data = json.decode(response.body)['suppliers'];
        final List<Supplier> suppliers =
            data.map((e) => Supplier.fromJson(e)).toList();
        return {'suppliers': suppliers, 'totalPage': totalPages};
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> addSupplier({required Supplier supplier}) async {
    try {
      final response = await http.post(
        Uri.parse("$urlApi/api/Supplier"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(supplier.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to send data');
    }
  }

  static Future<bool> updateSupplier({required Supplier supplier}) async {
    try {
      final response = await http.put(
        Uri.parse("$urlApi/api/Supplier"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(supplier.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to update data');
    }
  }

  static Future<bool> deleteSupplier({required int supplierId}) async {
    try {
      String url = "$urlApi/api/Supplier/?id=$supplierId";
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed');
    }
  }

  ///Purchase
  static Future<Map<String, dynamic>> getPurchases({
    String? filter = '',
    int? supplierId,
    int? pageNumber = 1,
    int? pageSize = 20,
    bool sortByNewest = false,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      String from = fromDate != null
          ? fromDate.toIso8601String()
          : DateTime.now().toIso8601String();
      String to = toDate != null
          ? toDate.toIso8601String()
          : DateTime.now().toIso8601String();

      String url =
          "$urlApi/api/Purchase?pageNumber=$pageNumber&pageSize=$pageSize&filterId=$filter&sortByNewest=$sortByNewest&fromDate=$from&toDate=$to";
      if (supplierId != null) {
        url += "&supplierId=$supplierId";
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final int totalPages = json.decode(response.body)['totalPage'];
        final List<dynamic> data = json.decode(response.body)['purchases'];
        final List<Purchase> purchases =
            data.map((e) => Purchase.fromJson(e)).toList();
        return {'purchases': purchases, 'totalPage': totalPages};
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> addPurchase({required Purchase purchase}) async {
    try {
      final response = await http.post(
        Uri.parse("$urlApi/api/Purchase"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(purchase.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to send data');
    }
  }

  ///Sale
  static Future<Map<String, dynamic>> getSales({
    String? filter = '',
    int? customerId,
    int? pageNumber = 1,
    int? pageSize = 20,
    bool sortByNewest = false,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      String from = fromDate != null
          ? fromDate.toIso8601String()
          : DateTime.now().toIso8601String();
      String to = toDate != null
          ? toDate.toIso8601String()
          : DateTime.now().toIso8601String();

      String url =
          "$urlApi/api/Sale?pageNumber=$pageNumber&pageSize=$pageSize&filter=$filter&sortByNewest=$sortByNewest&fromDate=$from&toDate=$to";
      if (customerId != null) {
        url += "&customerId=$customerId";
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final int totalPages = json.decode(response.body)['totalPage'];
        final List<dynamic> data = json.decode(response.body)['sales'];
        final List<Sale> sales = data.map((e) => Sale.fromJson(e)).toList();
        return {'sales': sales, 'totalPage': totalPages};
      } else {
        throw Exception('Failed to load data');
      }
    } catch (ex) {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> addSale({required Sale sale}) async {
    try {
      final response = await http.post(
        Uri.parse("$urlApi/api/Sale"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(sale.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception('Failed to send data');
    }
  }

  static Future<List<SaleData>> fetchDailySalesQuantity(DateTime? fromDate, DateTime? toDate) async {
    final response = await http.get(
      Uri.parse('$urlApi/api/Sale/daily-sales-quantity?fromDate=${fromDate!.toIso8601String()}&toDate=${toDate!.toIso8601String()}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SaleData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sales data');
    }
  }


  //return base64
  static Future<String> generateQRCode(double amount) async {
    try {
      final url = Uri.parse('$urlApi/api/Sale/GenerateQR?amount=$amount');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = response.body;
        return responseData;
      } else {
        throw Exception('Failed to generate QR code: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
