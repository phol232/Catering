import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_quote_request.dart';
import '../../domain/usecases/get_all_quotes.dart';
import '../../domain/usecases/get_quotes_by_client.dart';
import '../../domain/usecases/update_quote_status.dart';
import '../../domain/usecases/add_menu_to_quote.dart';
import '../../domain/usecases/remove_menu_from_quote.dart';
import '../../domain/usecases/get_quote_by_id.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final CreateQuoteRequest createQuoteRequest;
  final GetQuotesByClient getQuotesByClient;
  final GetAllQuotes getAllQuotes;
  final UpdateQuoteStatus updateQuoteStatus;
  final AddMenuToQuote addMenuToQuote;
  final RemoveMenuFromQuote removeMenuFromQuote;
  final GetQuoteById getQuoteById;

  QuoteBloc({
    required this.createQuoteRequest,
    required this.getQuotesByClient,
    required this.getAllQuotes,
    required this.updateQuoteStatus,
    required this.addMenuToQuote,
    required this.removeMenuFromQuote,
    required this.getQuoteById,
  }) : super(QuoteInitial()) {
    on<CreateQuoteRequestEvent>(_onCreateQuoteRequest);
    on<LoadQuotesByClientEvent>(_onLoadQuotesByClient);
    on<LoadAllQuotesEvent>(_onLoadAllQuotes);
    on<UpdateQuoteStatusEvent>(_onUpdateQuoteStatus);
    on<AddMenuToQuoteEvent>(_onAddMenuToQuote);
    on<RemoveMenuFromQuoteEvent>(_onRemoveMenuFromQuote);
    on<LoadQuoteByIdEvent>(_onLoadQuoteById);
  }

  Future<void> _onCreateQuoteRequest(
    CreateQuoteRequestEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    try {
      final quote = await createQuoteRequest(event.quote);
      emit(QuoteCreated(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  Future<void> _onLoadQuotesByClient(
    LoadQuotesByClientEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    try {
      final quotes = await getQuotesByClient(event.clientId);
      emit(QuotesLoaded(quotes));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  Future<void> _onLoadAllQuotes(
    LoadAllQuotesEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    try {
      final quotes = await getAllQuotes();
      emit(QuotesLoaded(quotes));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  Future<void> _onUpdateQuoteStatus(
    UpdateQuoteStatusEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    try {
      final quote = await updateQuoteStatus(
        event.quoteId,
        event.status,
        montoCotizado: event.montoCotizado,
        notasAdmin: event.notasAdmin,
      );
      emit(QuoteUpdated(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  Future<void> _onAddMenuToQuote(
    AddMenuToQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    try {
      await addMenuToQuote(event.quoteId, event.menuId);
      final quote = await getQuoteById(event.quoteId);
      emit(QuoteUpdated(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  Future<void> _onRemoveMenuFromQuote(
    RemoveMenuFromQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    try {
      await removeMenuFromQuote(event.quoteId, event.menuId);
      final quote = await getQuoteById(event.quoteId);
      emit(QuoteUpdated(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  Future<void> _onLoadQuoteById(
    LoadQuoteByIdEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    try {
      final quote = await getQuoteById(event.quoteId);
      emit(QuotesLoaded([quote]));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }
}
