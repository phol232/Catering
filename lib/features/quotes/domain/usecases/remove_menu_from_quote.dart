import '../repositories/quote_repository.dart';

class RemoveMenuFromQuote {
  final QuoteRepository repository;

  RemoveMenuFromQuote(this.repository);

  Future<void> call(int quoteId, int menuId) async {
    return await repository.removeMenuFromQuote(quoteId, menuId);
  }
}
