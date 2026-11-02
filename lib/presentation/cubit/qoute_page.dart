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
            final theme = Theme.of(context);

            if (state.status == CubitQuoteStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CubitQuoteStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.errorMessage ?? 'Something went wrong'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<QuoteCubit>().loadQuotes();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state.quotes.isEmpty) {
              return const Center(child: Text('No quotes available'));
            }

            final quote = state.quotes[state.currentIndex];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Index Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Quote ${state.currentIndex + 1} of ${state.quotes.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSecondaryContainer,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Main Quote Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            size: 56,
                            color: theme.colorScheme.primary.withOpacity(0.7),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '"${quote.quote}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 2,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                quote.author,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 24,
                                height: 2,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Action Controls
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filledTonal(
                          onPressed: () {
                            context.read<QuoteCubit>().previousQuote();
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Previous Quote',
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            context.read<QuoteCubit>().randomQuote();
                          },
                          icon: const Icon(Icons.shuffle_rounded),
                          label: const Text('Random'),
                        ),
                        IconButton.filledTonal(
                          onPressed: () {
                            context.read<QuoteCubit>().nextQuote();
                          },
                          icon: const Icon(Icons.arrow_forward_rounded),
                          tooltip: 'Next Quote',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
