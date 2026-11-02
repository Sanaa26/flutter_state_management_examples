import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/datasourace/quotes_local_data_source.dart';
import '../../data/repositories/quote_repository_impl.dart';
import '../../domain/entities/quote.dart';
import '../../domain/usecase/get_quotes.dart';

class QuotesPageState extends StatefulWidget {
  const QuotesPageState({super.key});
  @override
  State<QuotesPageState> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPageState> {
  late final GetQuotes getQuotes;
  List<Quote> quotes = [];
  bool isLoading = false;
  String? errorMessage;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final localDataSource = QuotesLocalDataSource();
    final repository = QuoteRepositoryImpl(localDataSource: localDataSource);
    getQuotes = GetQuotes(repository);
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await getQuotes();
      setState(() {
        quotes = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load quotes';
      });
    }
  }

  void nextQuote() {
    if (quotes.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % quotes.length;
    });
  }

  void previousQuote() {
    if (quotes.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex - 1 + quotes.length) % quotes.length;
    });
  }

  void randomQuote() {
    if (quotes.isEmpty) return;
    final random = Random();
    setState(() {
      currentIndex = random.nextInt(quotes.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState - Quotes'),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadQuotes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (quotes.isEmpty) {
      return const Center(child: Text('No quotes available'));
    }

    final quote = quotes[currentIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Index Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Quote ${currentIndex + 1} of ${quotes.length}',
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filledTonal(
                  onPressed: previousQuote,
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Previous Quote',
                ),
                FilledButton.icon(
                  onPressed: randomQuote,
                  icon: const Icon(Icons.shuffle_rounded),
                  label: const Text('Random'),
                ),
                IconButton.filledTonal(
                  onPressed: nextQuote,
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
  }
}
