import '../../domain/entities/quote.dart';

enum CubitQuoteStatus { initial, loading, success, failure }

class CubitQuoteState {
  final CubitQuoteStatus status;
  final List<Quote> quotes;
  final int currentIndex;
  final String? errorMessage;

  const CubitQuoteState({
    this.status = CubitQuoteStatus.initial,
    this.quotes = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  CubitQuoteState copyWith({
    CubitQuoteStatus? status,
    List<Quote>? quotes,
    int? currentIndex,
    String? errorMessage,
  }) {
    return CubitQuoteState(
      status: status ?? this.status,
      quotes: quotes ?? this.quotes,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
