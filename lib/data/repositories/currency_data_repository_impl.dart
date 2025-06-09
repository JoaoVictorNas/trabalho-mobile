import 'package:api_market_cap_coin/data/datasources/remote_currency_data_source.dart';
import 'package:api_market_cap_coin/domain/entities/digital_currency_model.dart';
import 'package:api_market_cap_coin/domain/repositories/currency_data_repository.dart';

class CurrencyDataRepositoryImpl implements CurrencyDataRepository {
  final RemoteCurrencyDataSource _remoteCurrencyDataSource;

  CurrencyDataRepositoryImpl(this._remoteCurrencyDataSource);

  @override
  Future<List<DigitalCurrencyModel>> fetchDigitalCurrencies(String currencySymbols) async {
    print('CurrencyDataRepositoryImpl: getting crypto currencies for symbols: $currencySymbols');
    try {
      final repositoryResult = await _remoteCurrencyDataSource.retrieveDigitalCurrencies(currencySymbols);
      print('CurrencyDataRepositoryImpl: received ${repositoryResult.length} currencies from data source.');
      return repositoryResult;
    } catch (e) {
      print('CurrencyDataRepositoryImpl: Error fetching crypto currencies: $e');
     
      rethrow;
    }
  }
}