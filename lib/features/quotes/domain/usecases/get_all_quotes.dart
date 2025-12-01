import '../entities/quote_request_entity.dart';
import '../repositories/quote_repository.dart';

class GetAllQuotes {
  final QuoteRepository repository;

  GetAllQuotes(this.repository);

  Future<List<QuoteRequestEntity>> call() async {
    return await repository.getAllQuotes();
  }
}
