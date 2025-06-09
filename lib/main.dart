import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_market_cap_coin/core/service/network_client.dart';
import 'package:api_market_cap_coin/data/datasources/remote_currency_data_source.dart';
import 'package:api_market_cap_coin/data/repositories/currency_data_repository_impl.dart';
import 'package:api_market_cap_coin/domain/repositories/currency_data_repository.dart';
import 'package:api_market_cap_coin/ui/view_models/currency_display_model.dart';
import 'package:api_market_cap_coin/ui/pages/currency_market_screen.dart';


void main() async {
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    final NetworkClient networkClient = NetworkClient();
    final RemoteCurrencyDataSource remoteDataSource = RemoteCurrencyDataSourceImpl(networkClient);
    final CurrencyDataRepository currencyRepository = CurrencyDataRepositoryImpl(remoteDataSource);

    return ChangeNotifierProvider(
      create: (context) => CurrencyDisplayModel(currencyRepository),
      child: MaterialApp(
        title: 'CoinMarketCap API Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple[400],
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)
            )
          )
        ),
        home: const CurrencyMarketScreen(),
      ),
    );
  }
}
