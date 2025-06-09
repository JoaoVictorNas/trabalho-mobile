import 'package:flutter/material.dart';
import 'package:api_market_cap_coin/domain/entities/digital_currency_model.dart';
import 'package:api_market_cap_coin/domain/repositories/currency_data_repository.dart';
import 'package:api_market_cap_coin/core/library/application_constants.dart';

enum ApplicationState { idle, loading, success, error }

class CurrencyDisplayModel extends ChangeNotifier {
  final CurrencyDataRepository _currencyDataRepository;

  CurrencyDisplayModel(this._currencyDataRepository);

  List<DigitalCurrencyModel> _digitalCurrencyList = [];
  List<DigitalCurrencyModel> get digitalCurrencyList => _digitalCurrencyList;

  ApplicationState _currentState = ApplicationState.idle;
  ApplicationState get currentState => _currentState;

  String _errorDescription = '';
  String get errorDescription => _errorDescription;

  Future<void> loadDigitalCurrencies({String? currencySymbols}) async {
    _currentState = ApplicationState.loading;
    notifyListeners();

    try {
      final symbolsToLoad = currencySymbols == null || currencySymbols.trim().isEmpty 
          ? ApplicationConstants.defaultCurrencySymbols 
          : currencySymbols.trim();
      
      print('CurrencyDisplayModel: Fetching with symbols: "$symbolsToLoad"');
      _digitalCurrencyList = await _currencyDataRepository.fetchDigitalCurrencies(symbolsToLoad);
      _currentState = ApplicationState.success;
      print('CurrencyDisplayModel: Successfully fetched ${_digitalCurrencyList.length} currencies.');
    } catch (e) {
      _errorDescription = e.toString();
      _currentState = ApplicationState.error;
      print('CurrencyDisplayModel: Error fetching currencies: $_errorDescription');
    }
    notifyListeners();
  }
}