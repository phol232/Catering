import '../entities/quote_request_entity.dart';
import '../repositories/quote_repository.dart';

class CreateQuoteRequest {
  final QuoteRepository repository;

  CreateQuoteRequest(this.repository);

  Future<QuoteRequestEntity> call(QuoteRequestEntity quote) async {
    return await repository.createQuoteRequest(quote);
  }
}
