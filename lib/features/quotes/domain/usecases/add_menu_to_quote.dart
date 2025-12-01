import '../repositories/quote_repository.dart';

class AddMenuToQuote {
  final QuoteRepository repository;

  AddMenuToQuote(this.repository);

  Future<void> call(int quoteId, int menuId) async {
    return await repository.addMenuToQuote(quoteId, menuId);
  }
}
