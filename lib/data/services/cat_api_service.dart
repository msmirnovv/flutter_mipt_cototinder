import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/cat_model.dart';

class CatApiService {
  final String _apiKey = dotenv.env['API_KEY'] ?? '';

  Future<CatModel> fetchRandomCat() async {
    final response = await http.get(
      Uri.parse(
        'https://api.thecatapi.com/v1/images/search?has_breeds=true&api_key=$_apiKey',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CatModel.fromJson(data[0]);
    } else {
      throw Exception('Failed to load cat');
    }
  }
}
