import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_market_cap_coin/configs/network_settings.dart';

enum RequestMethod { get, post, put, delete }

class NetworkClient {
  Future<dynamic> executeRequest({
    required String apiEndpoint,
    RequestMethod requestType = RequestMethod.get,
    Map<String, dynamic>? requestBody,
    Map<String, String>? additionalHeaders,
  }) async {
    final requestUrl = Uri.parse('${NetworkSettings.serverUrl}$apiEndpoint');
    final requestHeaders = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': NetworkSettings.authenticationKey,
      ...?additionalHeaders,
    };

    http.Response httpResponse;

    await Future.delayed(const Duration(seconds: 2));

    print('Request URL: $requestUrl');
    print('Request Method: $requestType');
    print('Request Headers: $requestHeaders');
    if (requestBody != null) {
      print('Request Body: ${jsonEncode(requestBody)}');
    }

    try {
      switch (requestType) {
        case RequestMethod.post:
          await Future.delayed(const Duration(seconds: 2));
          httpResponse = await http.post(requestUrl, headers: requestHeaders, body: jsonEncode(requestBody));
          break;
        case RequestMethod.put:
         await Future.delayed(const Duration(seconds: 2));
          httpResponse = await http.put(requestUrl, headers: requestHeaders, body: jsonEncode(requestBody));
          break;
        case RequestMethod.delete:
           await Future.delayed(const Duration(seconds: 2));
          httpResponse = await http.delete(requestUrl, headers: requestHeaders);
          break;
        case RequestMethod.get:
           await Future.delayed(const Duration(seconds: 2));
          httpResponse = await http.get(requestUrl, headers: requestHeaders);
          break;
      }

      print('Response Status Code: ${httpResponse.statusCode}');
      print('Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
        return jsonDecode(httpResponse.body);
      } else {
        print('Error: ${httpResponse.statusCode} - ${httpResponse.reasonPhrase}');
        print('Error Body: ${httpResponse.body}');
        
        throw Exception('Dados não carregados: ${httpResponse.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Exception during HTTP request: $e');
      print('Stack trace: $stackTrace');
      if (e == null) {
        
        throw Exception('HTTP request failed with a null error. This might be a network issue or CORS problem on web.');
      }
      
      throw Exception('Failed to make HTTP request: $e');
    }
  }
}