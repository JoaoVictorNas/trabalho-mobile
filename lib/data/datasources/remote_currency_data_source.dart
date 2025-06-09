import 'package:api_market_cap_coin/core/service/network_client.dart';
import 'package:api_market_cap_coin/domain/entities/digital_currency_model.dart';

abstract class RemoteCurrencyDataSource {
  Future<List<DigitalCurrencyModel>> retrieveDigitalCurrencies(String currencySymbols);
}

class RemoteCurrencyDataSourceImpl implements RemoteCurrencyDataSource {
  final NetworkClient _networkClient;

  RemoteCurrencyDataSourceImpl(this._networkClient);

  @override
  Future<List<DigitalCurrencyModel>> retrieveDigitalCurrencies(String currencySymbols) async {
    print('Fetching crypto currencies for symbols: $currencySymbols');
    try {
      final apiResponse = await _networkClient.executeRequest(
        apiEndpoint: '/v2/cryptocurrency/quotes/latest?symbol=$currencySymbols&convert=BRL',
      );

      print('Raw API Response: $apiResponse');

      if (apiResponse != null && apiResponse['data'] != null) {
        final Map<String, dynamic> responseData = apiResponse['data'];
        final List<DigitalCurrencyModel> currencyList = [];
        responseData.forEach((key, value) {
          if (value is List) { 
            for (var item in value) {
              if (item is Map<String, dynamic>) {
                 try {
                    currencyList.add(DigitalCurrencyModel.fromJson(item));
                 } catch (e) {
                    print('Error parsing item for key $key: $item. Error: $e');
                 }
              }
            }
          } else if (value is Map<String, dynamic>) {
             try {
                currencyList.add(DigitalCurrencyModel.fromJson(value));
             } catch (e) {
                print('Error parsing value for key $key: $value. Error: $e');
             }
          }
        });
        print('Parsed ${currencyList.length} currencies.');
        return currencyList;
      } else {
        print('No data found in response or response is null.');
        return [];
      }
    } catch (e) {
      print('Error in RemoteCurrencyDataSourceImpl.retrieveDigitalCurrencies: $e');
      throw Exception('Failed to fetch crypto currencies: $e');
    }
  }
}