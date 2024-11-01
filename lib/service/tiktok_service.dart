import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiktok_home_page_bloc/model/tiktok_model.dart';

class TiktokService {
  final String apiUrl = "https://my.api.mockaroo.com/tiktok.json?key=b8bc2ce0";
  
  Future<List<Tiktok>> fetchTiktokData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON data into a list of Tiktok objects
        return tiktokFromJson(response.body); 
      } else {
        throw Exception('Failed to load TikTok data');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error fetching data: $e');
    }
  }
}

// class TiktokService {
//   static Future<Tiktok?> getContent(String msg) async {
//     const url = "https://my.api.mockaroo.com/tiktok.json?key=b8bc2ce0";
//     try {
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         return Tiktok.fromJson(jsonDecode(response.body));
//       } else {
//         return Tiktok(error: "Error");
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       return Tiktok(error: "Error");
//     }
//   }
// }
