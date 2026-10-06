import '../../domain/entities/quote.dart';

enum QuoteStatus {
  initial,
  loading,
  success,
  failure,
}

class QuoteState {
  final QuoteStatus status;
  final List<Quote> quotes;
  final int currentIndex;
  final String? errorMessage;

  const QuoteState({
    this.status = QuoteStatus.initial,
    this.quotes = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  QuoteState copyWith({
    QuoteStatus? status,
    List<Quote>? quotes,
    int? currentIndex,
    String? errorMessage,
  }) {
    return QuoteState(
      status: status ?? this.status,
      quotes: quotes ?? this.quotes,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}