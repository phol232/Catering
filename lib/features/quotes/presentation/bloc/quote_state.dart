import 'package:equatable/equatable.dart';
import '../../domain/entities/quote_request_entity.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object?> get props => [];
}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteCreated extends QuoteState {
  final QuoteRequestEntity quote;

  const QuoteCreated(this.quote);

  @override
  List<Object?> get props => [quote];
}

class QuotesLoaded extends QuoteState {
  final List<QuoteRequestEntity> quotes;

  const QuotesLoaded(this.quotes);

  @override
  List<Object?> get props => [quotes];
}

class QuoteUpdated extends QuoteState {
  final QuoteRequestEntity quote;

  const QuoteUpdated(this.quote);

  @override
  List<Object?> get props => [quote];
}

class QuoteError extends QuoteState {
  final String message;

  const QuoteError(this.message);

  @override
  List<Object?> get props => [message];
}
