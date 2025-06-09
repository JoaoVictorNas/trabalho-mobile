import 'package:api_market_cap_coin/domain/entities/digital_currency_model.dart';

abstract class CurrencyDataRepository {
  Future<List<DigitalCurrencyModel>> fetchDigitalCurrencies(String currencySymbols);
}