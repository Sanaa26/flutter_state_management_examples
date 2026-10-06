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
      appBar: AppBar(title: const Text('Quotes'), centerTitle: true),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (quotes.isEmpty) {
      return const Center(child: Text('No quotes available'));
    }

    final quote = quotes[currentIndex];

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
                onPressed: previousQuote,
                icon: const Icon(Icons.arrow_back),
              ),

              ElevatedButton(
                onPressed: randomQuote,
                child: const Text('Random'),
              ),

              IconButton(
                onPressed: nextQuote,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text('${currentIndex + 1} / ${quotes.length}'),
        ],
      ),
    );
  }
}
