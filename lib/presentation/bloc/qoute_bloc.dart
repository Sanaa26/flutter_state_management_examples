import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_state_management_examples/presentation/bloc/qoute_event.dart';
import 'package:flutter_state_management_examples/presentation/bloc/qoute_state.dart';

import '../../domain/usecase/get_quotes.dart';



class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuotes getQuotes;

  QuoteBloc({
    required this.getQuotes,
  }) : super(const QuoteState()) {

    // Load quotes
    on<LoadQuotes>(_onLoadQuotes);

    // Next quote
    on<NextQuote>(_onNextQuote);

    // Previous quote
    on<PreviousQuote>(_onPreviousQuote);

    // Random quote
    on<RandomQuote>(_onRandomQuote);
  }

  Future<void> _onLoadQuotes(
      LoadQuotes event,
      Emitter<QuoteState> emit,
      ) async {
    emit(
      state.copyWith(
        status: QuoteStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final result = await getQuotes();

      emit(
        state.copyWith(
          status: QuoteStatus.success,
          quotes: result,
          currentIndex: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: QuoteStatus.failure,
          errorMessage: 'Failed to load quotes',
        ),
      );
    }
  }

  void _onNextQuote(
      NextQuote event,
      Emitter<QuoteState> emit,
      ) {
    if (state.quotes.isEmpty) return;

    final nextIndex =
        (state.currentIndex + 1) % state.quotes.length;

    emit(
      state.copyWith(
        currentIndex: nextIndex,
      ),
    );
  }

  void _onPreviousQuote(
      PreviousQuote event,
      Emitter<QuoteState> emit,
      ) {
    if (state.quotes.isEmpty) return;

    final previousIndex =
        (state.currentIndex - 1 + state.quotes.length) %
            state.quotes.length;

    emit(
      state.copyWith(
        currentIndex: previousIndex,
      ),
    );
  }

  void _onRandomQuote(
      RandomQuote event,
      Emitter<QuoteState> emit,
      ) {
    if (state.quotes.isEmpty) return;

    final random = Random();

    final randomIndex =
    random.nextInt(state.quotes.length);

    emit(
      state.copyWith(
        currentIndex: randomIndex,
      ),
    );
  }
}