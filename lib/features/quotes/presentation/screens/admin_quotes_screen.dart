import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';
import '../widgets/quote_card.dart';
import '../widgets/quote_detail_bottom_sheet.dart';

class AdminQuotesScreen extends StatefulWidget {
  const AdminQuotesScreen({super.key});

  @override
  State<AdminQuotesScreen> createState() => _AdminQuotesScreenState();
}

class _AdminQuotesScreenState extends State<AdminQuotesScreen> {
  String _filterStatus = 'TODOS';

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  void _loadQuotes() {
    context.read<QuoteBloc>().add(const LoadAllQuotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadQuotes),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<QuoteBloc, QuoteState>(
              listener: (context, state) {
                if (state is QuoteUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cotización actualizada'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadQuotes();
                }
              },
              builder: (context, state) {
                if (state is QuoteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is QuoteError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
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
                  final filteredQuotes = _filterStatus == 'TODOS'
                      ? state.quotes
                      : state.quotes
                            .where((q) => q.estado == _filterStatus)
                            .toList();

                  if (filteredQuotes.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.request_quote,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No hay cotizaciones'),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadQuotes(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredQuotes.length,
                      itemBuilder: (context, index) {
                        final quote = filteredQuotes[index];
                        return InkWell(
                          onTap: () {
                            final quoteBloc = context.read<QuoteBloc>();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (sheetContext) => BlocProvider.value(
                                value: quoteBloc,
                                child: QuoteDetailBottomSheet(quote: quote),
                              ),
                            );
                          },
                          child: QuoteCard(quote: quote),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      'TODOS',
      'PENDIENTE',
      'EN_REVISION',
      'COTIZADA',
      'ACEPTADA',
      'RECHAZADA',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _filterStatus == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_getFilterLabel(filter)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _filterStatus = filter);
                },
                selectedColor: AppColors.yellowPastel,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey[300],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'TODOS':
        return 'Todos';
      case 'PENDIENTE':
        return 'Pendientes';
      case 'EN_REVISION':
        return 'En Revisión';
      case 'COTIZADA':
        return 'Cotizadas';
      case 'ACEPTADA':
        return 'Aceptadas';
      case 'RECHAZADA':
        return 'Rechazadas';
      default:
        return filter;
    }
  }
}
