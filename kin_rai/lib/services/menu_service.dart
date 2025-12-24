import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class MenuService {
  static const String apiGetMenu = 'http://10.0.2.2/my_api/get_menus.php';

  static Future<List<MenuModel>> fetchMenus() async {
    // final response = await http.get(Uri.parse(apiUrl));

    // print('STATUS CODE: ${response.statusCode}');
    // print('RESPONSE BODY: ${response.body}');

    // if (response.statusCode == 200) {
    //   final jsonData = json.decode(response.body);
    //   final List list = jsonData['data'];
    //   return list.map((e) => MenuModel.fromJson(e)).toList();
    // } else {
    //   throw Exception('โหลดเมนูอาหารไม่สำเร็จ');
    // }

    try {
      final response = await http.get(Uri.parse(apiGetMenu));

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<MenuModel> menus = body
            .map((dynamic item) => MenuModel.fromJson(item))
            .toList();
        return menus;
      } else {
        throw Exception('Failed to load menus');
      }
    } catch (e) {
      throw Exception('Error: $e');
      return [];
    }
  }
}
