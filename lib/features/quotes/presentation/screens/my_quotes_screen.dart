import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/quote_request_entity.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';
import '../widgets/quote_card.dart';
import '../widgets/quote_detail_client_bottom_sheet.dart';

class MyQuotesScreen extends StatefulWidget {
  final Function(int)? onNavigateToMenus;

  const MyQuotesScreen({super.key, this.onNavigateToMenus});

  @override
  State<MyQuotesScreen> createState() => _MyQuotesScreenState();
}

class _MyQuotesScreenState extends State<MyQuotesScreen> {
  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  void _loadQuotes() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<QuoteBloc>().add(LoadQuotesByClientEvent(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        if (state is QuoteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is QuoteError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadQuotes,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is QuotesLoaded) {
          if (state.quotes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.request_quote, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tienes pedidos aún'),
                  SizedBox(height: 8),
                  Text(
                    'Crea tu primer pedido usando el botón de abajo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadQuotes(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                final quote = state.quotes[index];
                return QuoteCard(
                  quote: quote,
                  onTap: () => _showQuoteDetail(context, quote),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  void _showQuoteDetail(BuildContext context, QuoteRequestEntity quote) {
    final quoteBloc = context.read<QuoteBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: quoteBloc,
        child: QuoteDetailClientBottomSheet(
          quote: quote,
          onAddMenus: () {
            if (widget.onNavigateToMenus != null) {
              widget.onNavigateToMenus!(
                1,
              ); // Navegar a la pestaña de Menús (índice 1)
            }
          },
          onPaymentSuccess: () {
            // Recargar todas las cotizaciones del cliente
            quoteBloc.add(LoadQuotesByClientEvent(quote.clienteId));
          },
          onQuoteUpdated: () {
            // Recargar todas las cotizaciones después de confirmar
            quoteBloc.add(LoadQuotesByClientEvent(quote.clienteId));
          },
        ),
      ),
    );
  }
}
