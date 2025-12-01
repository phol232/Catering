import '../entities/quote_request_entity.dart';
import '../repositories/quote_repository.dart';

class UpdateQuoteStatus {
  final QuoteRepository repository;

  UpdateQuoteStatus(this.repository);

  Future<QuoteRequestEntity> call(
    int quoteId,
    String status, {
    double? montoCotizado,
    String? notasAdmin,
  }) async {
    return await repository.updateQuoteStatus(
      quoteId,
      status,
      montoCotizado: montoCotizado,
      notasAdmin: notasAdmin,
    );
  }
}
