import '../entities/quote_request_entity.dart';
import '../repositories/quote_repository.dart';

class GetQuoteById {
  final QuoteRepository repository;

  GetQuoteById(this.repository);

  Future<QuoteRequestEntity> call(int quoteId) async {
    return await repository.getQuoteById(quoteId);
  }
}
