import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promotion.dart';

class PromotionService {
  final String apiUrl = 'http://192.168.1.107:8090/promotions';

Future<List<Promotion>> fetchPromotions() async {
  final response = await http.get(Uri.parse('http://192.168.1.107:8090/promotions'));

  if (response.statusCode == 200) {
    List<dynamic> promotionsJson = json.decode(response.body);
    return promotionsJson.map((json) => Promotion.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load promotions');
  }
}


  // Ajouter ou mettre à jour une promotion
  Future<void> savePromotion(Promotion promotion) async {
    final url = promotion.id == 0
        ? Uri.parse(apiUrl)
        : Uri.parse('$apiUrl/${promotion.id}');
    
    final response = promotion.id == 0
        ? await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(promotion.toJson()),
          )
        : await http.put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(promotion.toJson()),
          );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save promotion');
    }
  }

  // Supprimer une promotion
  Future<void> deletePromotion(int promotionId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$promotionId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete promotion');
    }
  }
}
