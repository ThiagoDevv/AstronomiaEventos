import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/astronomy_event.dart';

class ApiService {
  static const String _baseUrl = 'https://api.nasa.gov';
  static const String _apiKey = 'LWMsTTjQgftD0iaat2D4jbP4SDCeGrxdSnHA2FfB'; // Substitua pela sua chave.

  /// Busca eventos astronômicos dentro de um intervalo de datas personalizado
  static Future<List<AstronomyEvent>> fetchAstronomyEvents({
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/planetary/apod?api_key=$_apiKey&start_date=$startDate&end_date=$endDate',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AstronomyEvent.fromJson(item)).toList();
    } else {
      print('Erro ao carregar eventos: ${response.body}');
      throw Exception('Erro ao carregar eventos.');
    }
  }
}
