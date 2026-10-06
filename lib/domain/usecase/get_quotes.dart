import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetQuotes {
  final QuoteRepository repository;

  GetQuotes(this.repository);

  Future<List<Quote>> call() async {
    return await repository.getQuotes();
  }
}