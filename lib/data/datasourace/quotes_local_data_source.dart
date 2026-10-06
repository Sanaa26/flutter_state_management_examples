import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/quote_model.dart';



class QuotesLocalDataSource {
  Future<List<QuoteModel>> getQuotes() async {
    final jsonString = await rootBundle.loadString(
      'assets/quotes.json',
    );

    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((json) => QuoteModel.fromJson(json))
        .toList();
  }
}