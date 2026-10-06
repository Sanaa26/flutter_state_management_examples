import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_quotes.dart';
import 'qoute_state.dart';

class QuoteCubit extends Cubit<CubitQuoteState> {
  final GetQuotes getQuotes;

  QuoteCubit({required this.getQuotes}) : super(const CubitQuoteState());

  Future<void> loadQuotes() async {
    emit(state.copyWith(status: CubitQuoteStatus.loading));

    try {
      final quotes = await getQuotes();
      emit(
        state.copyWith(
          status: CubitQuoteStatus.success,
          quotes: quotes,
          currentIndex: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CubitQuoteStatus.failure,
          errorMessage: 'Failed to load quotes',
        ),
      );
    }
  }

  void nextQuote() {
    if (state.quotes.isEmpty) return;
    final nextIndex = (state.currentIndex + 1) % state.quotes.length;
    emit(state.copyWith(currentIndex: nextIndex));
  }

  void previousQuote() {
    if (state.quotes.isEmpty) return;
    final prevIndex =
        (state.currentIndex - 1 + state.quotes.length) % state.quotes.length;
    emit(state.copyWith(currentIndex: prevIndex));
  }

  void randomQuote() {
    if (state.quotes.isEmpty) return;
    final random = Random();
    emit(state.copyWith(currentIndex: random.nextInt(state.quotes.length)));
  }
}
