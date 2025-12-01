import 'package:equatable/equatable.dart';
import '../../domain/entities/quote_request_entity.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object?> get props => [];
}

class CreateQuoteRequestEvent extends QuoteEvent {
  final QuoteRequestEntity quote;

  const CreateQuoteRequestEvent(this.quote);

  @override
  List<Object?> get props => [quote];
}

class LoadQuotesByClientEvent extends QuoteEvent {
  final int clientId;

  const LoadQuotesByClientEvent(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class LoadAllQuotesEvent extends QuoteEvent {
  const LoadAllQuotesEvent();
}

class UpdateQuoteStatusEvent extends QuoteEvent {
  final int quoteId;
  final String status;
  final double? montoCotizado;
  final String? notasAdmin;

  const UpdateQuoteStatusEvent({
    required this.quoteId,
    required this.status,
    this.montoCotizado,
    this.notasAdmin,
  });

  @override
  List<Object?> get props => [quoteId, status, montoCotizado, notasAdmin];
}

class AddMenuToQuoteEvent extends QuoteEvent {
  final int quoteId;
  final int menuId;

  const AddMenuToQuoteEvent(this.quoteId, this.menuId);

  @override
  List<Object?> get props => [quoteId, menuId];
}

class RemoveMenuFromQuoteEvent extends QuoteEvent {
  final int quoteId;
  final int menuId;

  const RemoveMenuFromQuoteEvent(this.quoteId, this.menuId);

  @override
  List<Object?> get props => [quoteId, menuId];
}

class LoadQuoteByIdEvent extends QuoteEvent {
  final int quoteId;

  const LoadQuoteByIdEvent(this.quoteId);

  @override
  List<Object?> get props => [quoteId];
}
