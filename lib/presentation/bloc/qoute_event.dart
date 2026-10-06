import '../../domain/entities/quote.dart';

abstract class QuoteEvent {}

class LoadQuotes extends QuoteEvent {}

class NextQuote extends QuoteEvent {}

class PreviousQuote extends QuoteEvent {}

class RandomQuote extends QuoteEvent {}