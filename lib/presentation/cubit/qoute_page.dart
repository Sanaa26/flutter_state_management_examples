import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasourace/quotes_local_data_source.dart';
import '../../data/repositories/quote_repository_impl.dart';
import '../../domain/usecase/get_quotes.dart';
import 'qoute_cubit.dart';
import 'qoute_state.dart';

class CubitQuotesPage extends StatelessWidget {
  const CubitQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = QuotesLocalDataSource();
    final repository = QuoteRepositoryImpl(localDataSource: localDataSource);
    final getQuotes = GetQuotes(repository);

    return BlocProvider(
      create: (_) => QuoteCubit(getQuotes: getQuotes)..loadQuotes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cubit - Quotes'),
          centerTitle: true,
        ),
        body: BlocBuilder<QuoteCubit, CubitQuoteState>(
          builder: (context, state) {
            if (state.status == CubitQuoteStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CubitQuoteStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            if (state.quotes.isEmpty) {
              return const Center(child: Text('No quotes available'));
            }

            final quote = state.quotes[state.currentIndex];

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.format_quote, size: 50),
                          const SizedBox(height: 20),
                          Text(
                            '"${quote.quote}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '- ${quote.author}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<QuoteCubit>().previousQuote();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<QuoteCubit>().randomQuote();
                        },
                        child: const Text('Random'),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<QuoteCubit>().nextQuote();
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('${state.currentIndex + 1} / ${state.quotes.length}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
