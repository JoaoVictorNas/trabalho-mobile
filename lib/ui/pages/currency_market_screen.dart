import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:api_market_cap_coin/ui/view_models/currency_display_model.dart';
import 'package:api_market_cap_coin/domain/entities/digital_currency_model.dart';

class CurrencyMarketScreen extends StatefulWidget {
  const CurrencyMarketScreen({super.key});

  @override
  State<CurrencyMarketScreen> createState() => _CurrencyMarketScreenState();
}

class _CurrencyMarketScreenState extends State<CurrencyMarketScreen> {
  final TextEditingController _searchInputController = TextEditingController();
  final NumberFormat _dollarFormatter = NumberFormat.currency(locale: 'en_US', symbol: 'USD ');
  final NumberFormat _realFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'BRL ');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrencyDisplayModel>(context, listen: false).loadDigitalCurrencies();
    });
  }

  void _displayCurrencyDetails(BuildContext context, DigitalCurrencyModel digitalCurrency) {
    final dollarPrice = digitalCurrency.priceQuotes['USD']?.currentPrice ?? 0.0;
    final realPrice = digitalCurrency.priceQuotes['BRL']?.currentPrice ?? 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[800],
                child: Text(
                  digitalCurrency.currencySymbol.substring(0, digitalCurrency.currencySymbol.length > 2 ? 2 : digitalCurrency.currencySymbol.length),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      digitalCurrency.currencyName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      digitalCurrency.currencySymbol,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _createDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Date Added',
                  value: DateFormat.yMd().add_jms().format(digitalCurrency.creationDate.toLocal()),
                ),
                const SizedBox(height: 16),
                _createDetailRow(
                  icon: Icons.attach_money,
                  label: 'Price (USD)',
                  value: _dollarFormatter.format(dollarPrice),
                  valueColor: Colors.green[400],
                ),
                const SizedBox(height: 16),
                _createDetailRow(
                  icon: Icons.monetization_on,
                  label: 'Price (BRL)',
                  value: _realFormatter.format(realPrice),
                  valueColor: Colors.blue[400],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[400],
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[400],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

 @override
  Widget build(BuildContext context) {
    final displayModel = Provider.of<CurrencyDisplayModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Crypto Market Cap',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchInputController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Search Symbols (e.g., BTC, ETH)',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.grey[400]),
                    onPressed: () {
                      displayModel.loadDigitalCurrencies(currencySymbols: _searchInputController.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[500]!, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                onSubmitted: (value) {
                  displayModel.loadDigitalCurrencies(currencySymbols: value);
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => displayModel.loadDigitalCurrencies(currencySymbols: _searchInputController.text.isEmpty ? null : _searchInputController.text),
              color: Colors.grey[400],
              backgroundColor: Colors.grey[800],
              child: _buildCurrencyListView(displayModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyListView(CurrencyDisplayModel displayModel) {
    if (displayModel.currentState == ApplicationState.loading && displayModel.digitalCurrencyList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading cryptocurrencies...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    if (displayModel.currentState == ApplicationState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load data: ${displayModel.errorDescription}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (displayModel.digitalCurrencyList.isEmpty && displayModel.currentState == ApplicationState.success) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No cryptocurrencies found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for different symbols',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    if (displayModel.digitalCurrencyList.isEmpty && displayModel.currentState == ApplicationState.loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: displayModel.digitalCurrencyList.length,
      itemBuilder: (context, index) {
        final digitalCurrency = displayModel.digitalCurrencyList[index];
        final dollarPrice = digitalCurrency.priceQuotes['USD']?.currentPrice ?? 0.0;
        final realPrice = digitalCurrency.priceQuotes['BRL']?.currentPrice ?? 0.0;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[800],
              child: Text(
                digitalCurrency.currencySymbol.substring(0, digitalCurrency.currencySymbol.length > 2 ? 2 : digitalCurrency.currencySymbol.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            title: Text(
              '${digitalCurrency.currencyName} (${digitalCurrency.currencySymbol})',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'USD: ${_dollarFormatter.format(dollarPrice)}',
                      style: TextStyle(
                        color: Colors.green[400],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'BRL: ${_realFormatter.format(realPrice)}',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 16,
            ),
            onTap: () => _displayCurrencyDetails(context, digitalCurrency),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    super.dispose();
  }
}