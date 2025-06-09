class DigitalCurrencyModel {
  final int currencyId;
  final String currencyName;
  final String currencySymbol;
  final String currencySlug;
  final DateTime creationDate;
  final Map<String, PriceQuoteModel> priceQuotes;

  DigitalCurrencyModel({
    required this.currencyId,
    required this.currencyName,
    required this.currencySymbol,
    required this.currencySlug,
    required this.creationDate,
    required this.priceQuotes,
  });

  factory DigitalCurrencyModel.fromJson(Map<String, dynamic> json) {
    return DigitalCurrencyModel(
      currencyId: json['id'] ?? 0,
      currencyName: json['name'] ?? '',
      currencySymbol: json['symbol'] ?? '',
      currencySlug: json['slug'] ?? '',
      creationDate: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : DateTime.now(),
      priceQuotes: (json['quote'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, PriceQuoteModel.fromJson(value)),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id': currencyId,
    'name': currencyName,
    'symbol': currencySymbol,
    'slug': currencySlug,
    'date_added': creationDate.toIso8601String(),
    'quote': priceQuotes.map((key, value) => MapEntry(key, value.toJson())),
  };
}

class PriceQuoteModel {
  final double currentPrice;
  final double dailyVolume;
  final double hourlyChange;
  final double dailyChange;
  final double weeklyChange;
  final double totalMarketCap;
  final DateTime lastUpdateTime;

  PriceQuoteModel({
    required this.currentPrice,
    required this.dailyVolume,
    required this.hourlyChange,
    required this.dailyChange,
    required this.weeklyChange,
    required this.totalMarketCap,
    required this.lastUpdateTime,
  });

  factory PriceQuoteModel.fromJson(Map<String, dynamic> json) {
    return PriceQuoteModel(
      currentPrice: (json['price'] ?? 0.0).toDouble(),
      dailyVolume: (json['volume_24h'] ?? 0.0).toDouble(),
      hourlyChange: (json['percent_change_1h'] ?? 0.0).toDouble(),
      dailyChange: (json['percent_change_24h'] ?? 0.0).toDouble(),
      weeklyChange: (json['percent_change_7d'] ?? 0.0).toDouble(),
      totalMarketCap: (json['market_cap'] ?? 0.0).toDouble(),
      lastUpdateTime: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
    );
  }
   Map<String, dynamic> toJson() => {
    'price': currentPrice,
    'volume_24h': dailyVolume,
    'percent_change_1h': hourlyChange,
    'percent_change_24h': dailyChange,
    'percent_change_7d': weeklyChange,
    'market_cap': totalMarketCap,
    'last_updated': lastUpdateTime.toIso8601String(),
  };
}