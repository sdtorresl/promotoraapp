import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:mi_promotora/models/sales_model.dart';
import 'package:mi_promotora/preferences/users_preferences.dart';
import 'package:intl/intl.dart';

class SalesProvider {
  final String _url = GlobalConfiguration().getValue("api_url");
  final _prefs = new UserPreferences();

  Future<bool> sendSale(String type, String date, String value, String client,
      String idclient, String user) async {
    final bodyData = json.encode(
      {
        'type': type,
        'date': date,
        'value': value,
        'client': client,
        'id_client': idclient,
        'user': user
      },
    );
    print(bodyData);
    String token = _prefs.token;

    final resp = await http.post(
      _url + "/ventas",
      headers: {
        'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: bodyData,
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getSalesCount() async {
    int sales;
    String priv = _prefs.token;
    try {
      int id = _prefs.userId;
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-01');
      String formattedDate = formatter.format(now);

      String requestUrl =
          _url + "/ventas/count?user=$id&created_at_gte=$formattedDate";
      print(requestUrl);

      final response = await http.get(
        requestUrl,
        headers: {'Authorization': 'Bearer $priv'},
      );

      if (response.statusCode == 200) {
        sales = int.parse(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        sales = 0;
      }
    } catch (Exception) {
      print(Exception);
    }
    return sales;
  }

  Future<List<SalesCategoryModel>> getSalesCategories() async {
    List<SalesCategoryModel> salesCategories = [];

    try {
      String token = _prefs.token;
      String salesCategoriesUrl = _url + "/ventas-categorias";

      final response = await http.get(
        salesCategoriesUrl,
        /* headers: {
          'Authorization': 'Bearer $token',
        }, */
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> jsonResponse = jsonDecode(response.body);

        for (var item in jsonResponse) {
          SalesCategoryModel saleCategory = SalesCategoryModel.fromMap(item);
          salesCategories.add(saleCategory);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (Exception) {
      print(Exception);
    }

    return salesCategories;
  }

  Future<List<SaleModel>> getSalesByUser(int categoryId, int userId) async {
    List<SaleModel> sales = [];

    try {
      String token = _prefs.token;
      String salesCategoriesUrl =
          '$_url/ventas?user.id=$userId&category.id=$categoryId';

      print(salesCategoriesUrl);

      final response = await http.get(
        salesCategoriesUrl,
        /* headers: {
          'Authorization': 'Bearer $token',
        }, */
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> jsonResponse = jsonDecode(response.body);

        for (var item in jsonResponse) {
          SaleModel sale = SaleModel.fromMap(item);
          sales.add(sale);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (Exception) {
      print(Exception);
    }

    return sales;
  }
}
