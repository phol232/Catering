import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote_request_model.dart';

abstract class QuoteRemoteDataSource {
  Future<QuoteRequestModel> createQuoteRequest(QuoteRequestModel quote);
  Future<List<QuoteRequestModel>> getQuotesByClient(int clientId);
  Future<List<QuoteRequestModel>> getAllQuotes();
  Future<QuoteRequestModel> updateQuoteStatus(
    int quoteId,
    String status, {
    double? montoCotizado,
    String? notasAdmin,
  });
  Future<void> deleteQuote(int quoteId);
  Future<void> addMenuToQuote(int quoteId, int menuId);
  Future<void> removeMenuFromQuote(int quoteId, int menuId);
  Future<QuoteRequestModel> getQuoteById(int quoteId);
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final SupabaseClient supabaseClient;

  QuoteRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<QuoteRequestModel> createQuoteRequest(QuoteRequestModel quote) async {
    try {
      // 1. Insertar la cotización principal
      final response = await supabaseClient
          .from('quote_requests')
          .insert(quote.toJson())
          .select()
          .single();

      final quoteId = response['id'] as int;

      // 2. Insertar restricciones alimentarias si existen
      if (quote.tieneRestricciones && quote.detallesRestricciones != null) {
        await supabaseClient.from('quote_dietary_restrictions').insert({
          'quote_request_id': quoteId,
          'descripcion': quote.detallesRestricciones,
        });
      }

      // 3. Insertar servicios adicionales
      final servicios = <Map<String, dynamic>>[];

      if (quote.necesitaMeseros) {
        servicios.add({
          'quote_request_id': quoteId,
          'servicio': 'meseros',
          'descripcion': null,
        });
      }

      if (quote.necesitaMontaje) {
        servicios.add({
          'quote_request_id': quoteId,
          'servicio': 'montaje',
          'descripcion': null,
        });
      }

      if (quote.necesitaDecoracion) {
        servicios.add({
          'quote_request_id': quoteId,
          'servicio': 'decoracion',
          'descripcion': null,
        });
      }

      if (quote.necesitaSonido) {
        servicios.add({
          'quote_request_id': quoteId,
          'servicio': 'sonido',
          'descripcion': null,
        });
      }

      if (quote.otrosServicios != null && quote.otrosServicios!.isNotEmpty) {
        servicios.add({
          'quote_request_id': quoteId,
          'servicio': 'otros',
          'descripcion': quote.otrosServicios,
        });
      }

      if (servicios.isNotEmpty) {
        await supabaseClient
            .from('quote_additional_services')
            .insert(servicios);
      }

      return QuoteRequestModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create quote request: $e');
    }
  }

  @override
  Future<List<QuoteRequestModel>> getQuotesByClient(int clientId) async {
    try {
      final response = await supabaseClient
          .from('quote_requests')
          .select('''
            *, 
            users!cliente_id(nombre),
            quote_dietary_restrictions(descripcion),
            quote_additional_services(servicio, descripcion),
            quote_menus(menu_id, menus(*))
          ''')
          .eq('cliente_id', clientId)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        return _processQuoteJson(json);
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }

  /// Procesa el JSON de una cotización con sus relaciones
  QuoteRequestModel _processQuoteJson(Map<String, dynamic> json) {
    // Agregar el nombre del cliente
    if (json['users'] != null) {
      json['cliente_nombre'] = json['users']['nombre'];
    }

    // Procesar restricciones alimentarias
    if (json['quote_dietary_restrictions'] != null) {
      final restrictions = json['quote_dietary_restrictions'] as List;
      if (restrictions.isNotEmpty) {
        json['tiene_restricciones'] = true;
        json['detalles_restricciones'] = restrictions[0]['descripcion'];
      }
    }

    // Procesar servicios adicionales
    if (json['quote_additional_services'] != null) {
      final services = json['quote_additional_services'] as List;
      for (var service in services) {
        final serviceName = service['servicio'] as String;
        switch (serviceName) {
          case 'meseros':
            json['necesita_meseros'] = true;
            break;
          case 'montaje':
            json['necesita_montaje'] = true;
            break;
          case 'decoracion':
            json['necesita_decoracion'] = true;
            break;
          case 'sonido':
            json['necesita_sonido'] = true;
            break;
          case 'otros':
            json['otros_servicios'] = service['descripcion'];
            break;
        }
      }
    }

    // Procesar menús
    if (json['quote_menus'] != null) {
      final quoteMenus = json['quote_menus'] as List;
      json['menus'] = quoteMenus
          .where((qm) => qm['menus'] != null)
          .map((qm) => qm['menus'])
          .toList();
    }

    return QuoteRequestModel.fromJson(json);
  }

  @override
  Future<List<QuoteRequestModel>> getAllQuotes() async {
    try {
      final response = await supabaseClient
          .from('quote_requests')
          .select('''
            *, 
            users!cliente_id(nombre),
            quote_dietary_restrictions(descripcion),
            quote_additional_services(servicio, descripcion),
            quote_menus(menu_id, menus(*))
          ''')
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        return _processQuoteJson(json);
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch all quotes: $e');
    }
  }

  @override
  Future<QuoteRequestModel> updateQuoteStatus(
    int quoteId,
    String status, {
    double? montoCotizado,
    String? notasAdmin,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'estado': status,
        if (montoCotizado != null) 'monto_cotizado': montoCotizado,
        if (notasAdmin != null) 'notas_admin': notasAdmin,
      };

      final response = await supabaseClient
          .from('quote_requests')
          .update(updateData)
          .eq('id', quoteId)
          .select()
          .single();

      return QuoteRequestModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update quote: $e');
    }
  }

  @override
  Future<void> deleteQuote(int quoteId) async {
    try {
      await supabaseClient.from('quote_requests').delete().eq('id', quoteId);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete quote: $e');
    }
  }

  @override
  Future<void> addMenuToQuote(int quoteId, int menuId) async {
    try {
      await supabaseClient.from('quote_menus').insert({
        'quote_request_id': quoteId,
        'menu_id': menuId,
      });
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add menu to quote: $e');
    }
  }

  @override
  Future<void> removeMenuFromQuote(int quoteId, int menuId) async {
    try {
      await supabaseClient
          .from('quote_menus')
          .delete()
          .eq('quote_request_id', quoteId)
          .eq('menu_id', menuId);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to remove menu from quote: $e');
    }
  }

  @override
  Future<QuoteRequestModel> getQuoteById(int quoteId) async {
    try {
      final response = await supabaseClient
          .from('quote_requests')
          .select('''
            *, 
            users!cliente_id(nombre),
            quote_dietary_restrictions(descripcion),
            quote_additional_services(servicio, descripcion),
            quote_menus(menu_id, menus(*))
          ''')
          .eq('id', quoteId)
          .single();

      return _processQuoteJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch quote: $e');
    }
  }
}
