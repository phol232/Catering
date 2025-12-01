import '../entities/quote_request_entity.dart';
import '../repositories/quote_repository.dart';

class GetQuotesByClient {
  final QuoteRepository repository;

  GetQuotesByClient(this.repository);

  Future<List<QuoteRequestEntity>> call(int clientId) async {
    return await repository.getQuotesByClient(clientId);
  }
}
