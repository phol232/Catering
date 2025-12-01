import '../../domain/entities/quote_request_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_datasource.dart';
import '../models/quote_request_model.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;

  QuoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<QuoteRequestEntity> createQuoteRequest(
    QuoteRequestEntity quote,
  ) async {
    final model = QuoteRequestModel(
      clienteId: quote.clienteId,
      nombreEvento: quote.nombreEvento,
      tipoEvento: quote.tipoEvento,
      fechaEvento: quote.fechaEvento,
      horaInicio: quote.horaInicio,
      horaFin: quote.horaFin,
      numInvitados: quote.numInvitados,
      direccion: quote.direccion,
      ciudad: quote.ciudad,
      tipoServicio: quote.tipoServicio,
      descripcion: quote.descripcion,
      presupuestoAproximado: quote.presupuestoAproximado,
      tieneRestricciones: quote.tieneRestricciones,
      detallesRestricciones: quote.detallesRestricciones,
      necesitaMeseros: quote.necesitaMeseros,
      necesitaMontaje: quote.necesitaMontaje,
      necesitaDecoracion: quote.necesitaDecoracion,
      necesitaSonido: quote.necesitaSonido,
      otrosServicios: quote.otrosServicios,
      telefonoContacto: quote.telefonoContacto,
      emailContacto: quote.emailContacto,
    );
    return await remoteDataSource.createQuoteRequest(model);
  }

  @override
  Future<List<QuoteRequestEntity>> getQuotesByClient(int clientId) async {
    return await remoteDataSource.getQuotesByClient(clientId);
  }

  @override
  Future<List<QuoteRequestEntity>> getAllQuotes() async {
    return await remoteDataSource.getAllQuotes();
  }

  @override
  Future<QuoteRequestEntity> updateQuoteStatus(
    int quoteId,
    String status, {
    double? montoCotizado,
    String? notasAdmin,
  }) async {
    return await remoteDataSource.updateQuoteStatus(
      quoteId,
      status,
      montoCotizado: montoCotizado,
      notasAdmin: notasAdmin,
    );
  }

  @override
  Future<void> deleteQuote(int quoteId) async {
    await remoteDataSource.deleteQuote(quoteId);
  }

  @override
  Future<void> addMenuToQuote(int quoteId, int menuId) async {
    await remoteDataSource.addMenuToQuote(quoteId, menuId);
  }

  @override
  Future<void> removeMenuFromQuote(int quoteId, int menuId) async {
    await remoteDataSource.removeMenuFromQuote(quoteId, menuId);
  }

  @override
  Future<QuoteRequestEntity> getQuoteById(int quoteId) async {
    return await remoteDataSource.getQuoteById(quoteId);
  }
}
