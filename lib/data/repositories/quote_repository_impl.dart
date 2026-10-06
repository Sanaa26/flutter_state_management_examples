import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasourace/quotes_local_data_source.dart';


class QuoteRepositoryImpl implements QuoteRepository {
  final QuotesLocalDataSource localDataSource;

  QuoteRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Quote>> getQuotes() async {
    return await localDataSource.getQuotes();
  }
}