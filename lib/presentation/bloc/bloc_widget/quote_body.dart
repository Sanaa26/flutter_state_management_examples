import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../qoute_bloc.dart';
import '../qoute_event.dart';
import '../qoute_state.dart';

class QuoteBody extends StatelessWidget {
  const QuoteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {

        // Loading
        if (state.status == QuoteStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (state.status == QuoteStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
            ),
          );
        }

        // No quotes
        if (state.quotes.isEmpty) {
          return const Center(
            child: Text('No quotes available'),
          );
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

                      const Icon(
                        Icons.format_quote,
                        size: 50,
                      ),

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
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [

                  // Previous
                  IconButton(
                    onPressed: () {
                      context.read<QuoteBloc>().add(
                        PreviousQuote(),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  // Random
                  ElevatedButton(
                    onPressed: () {
                      context.read<QuoteBloc>().add(
                        RandomQuote(),
                      );
                    },
                    child: const Text('Random'),
                  ),

                  // Next
                  IconButton(
                    onPressed: () {
                      context.read<QuoteBloc>().add(
                        NextQuote(),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                '${state.currentIndex + 1} / ${state.quotes.length}',
              ),
            ],
          ),
        );
      },
    );
  }
}