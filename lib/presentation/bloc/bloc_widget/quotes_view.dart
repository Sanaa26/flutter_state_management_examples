import 'package:flutter/material.dart';
import 'package:flutter_state_management_examples/presentation/bloc/bloc_widget/quote_body.dart';

class QuotesView extends StatelessWidget {
  const QuotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
        centerTitle: true,
      ),
      body: const QuoteBody(),
    );
  }
}