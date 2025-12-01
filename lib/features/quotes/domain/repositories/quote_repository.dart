import '../entities/quote_request_entity.dart';

abstract class QuoteRepository {
  Future<QuoteRequestEntity> createQuoteRequest(QuoteRequestEntity quote);
  Future<List<QuoteRequestEntity>> getQuotesByClient(int clientId);
  Future<List<QuoteRequestEntity>> getAllQuotes();
  Future<QuoteRequestEntity> updateQuoteStatus(
    int quoteId,
    String status, {
    double? montoCotizado,
    String? notasAdmin,
  });
  Future<void> deleteQuote(int quoteId);
  Future<void> addMenuToQuote(int quoteId, int menuId);
  Future<void> removeMenuFromQuote(int quoteId, int menuId);
  Future<QuoteRequestEntity> getQuoteById(int quoteId);
}
