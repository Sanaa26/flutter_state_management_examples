import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_management_examples/presentation/bloc/bloc_widget/quotes_view.dart';


import '../../../data/datasourace/quotes_local_data_source.dart';
import '../../../data/repositories/quote_repository_impl.dart';
import '../../../domain/usecase/get_quotes.dart';
import '../qoute_bloc.dart';
import '../qoute_event.dart';


class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = QuotesLocalDataSource();

    final repository = QuoteRepositoryImpl(
      localDataSource: localDataSource,
    );

    final getQuotes = GetQuotes(repository);

    return BlocProvider(
      create: (_) => QuoteBloc(
        getQuotes: getQuotes,
      )..add(LoadQuotes()),

      child: const QuotesView(),
    );
  }
}