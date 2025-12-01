import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/event_form_bottom_sheet.dart';

/// Event management screen - displays list of events with CRUD operations
class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EventBloc>()..add(LoadAllEvents()),
      child: Builder(
        builder: (context) => BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventOperationSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 1),
                ),
              );
              // Reload events list
              context.read<EventBloc>().add(LoadAllEvents());
            } else if (state is EventError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.black,
            appBar: AppBar(
              backgroundColor: AppColors.grayDark,
              title: const Text(
                'Eventos',
                style: TextStyle(color: AppColors.whiteAlmost),
              ),
            ),
            body: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: AppColors.whiteAlmost),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre...',
                      hintStyle: const TextStyle(color: AppColors.grayLight),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.grayLight,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.grayLight,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.grayDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value.toLowerCase());
                    },
                  ),
                ),
                // Events grid
                Expanded(
                  child: BlocBuilder<EventBloc, EventState>(
                    builder: (context, state) {
                      if (state is EventLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.yellowPastel,
                            ),
                          ),
                        );
                      }

                      if (state is EventError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${state.message}',
                                style: const TextStyle(
                                  color: AppColors.grayLight,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<EventBloc>().add(
                                    LoadAllEvents(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.yellowPastel,
                                  foregroundColor: AppColors.black,
                                ),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is EventsLoaded) {
                        // Sort events by date descending (most recent first)
                        var sortedEvents = List.from(state.events)
                          ..sort((a, b) => b.fecha.compareTo(a.fecha));

                        // Filter by search query
                        if (_searchQuery.isNotEmpty) {
                          sortedEvents = sortedEvents
                              .where(
                                (event) => event.nombreEvento
                                    .toLowerCase()
                                    .contains(_searchQuery),
                              )
                              .toList();
                        }

                        if (sortedEvents.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty
                                      ? Icons.search_off
                                      : Icons.event_busy,
                                  color: AppColors.grayLight,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No se encontraron eventos'
                                      : 'No hay eventos',
                                  style: const TextStyle(
                                    color: AppColors.grayLight,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Intenta con otro término de búsqueda'
                                      : 'Crea tu primer evento para comenzar',
                                  style: const TextStyle(
                                    color: AppColors.grayLight,
                                    fontSize: 14,
                                  ),
                                ),
                                if (_searchQuery.isEmpty) ...[
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _showEventFormBottomSheet(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.yellowPastel,
                                      foregroundColor: AppColors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Crear Primer Evento'),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: sortedEvents.length,
                          itemBuilder: (context, index) {
                            final event = sortedEvents[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.grayDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Image (Left)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child:
                                        event.imageUrl != null &&
                                            event.imageUrl!.isNotEmpty
                                        ? Image.network(
                                            event.imageUrl!,
                                            width: 120,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 120,
                                                    height: 140,
                                                    color: AppColors.black,
                                                    child: const Icon(
                                                      Icons.event,
                                                      color:
                                                          AppColors.grayLight,
                                                      size: 40,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            width: 120,
                                            height: 140,
                                            color: AppColors.black,
                                            child: const Icon(
                                              Icons.event,
                                              color: AppColors.grayLight,
                                              size: 40,
                                            ),
                                          ),
                                  ),
                                  // Event Info (Right)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.nombreEvento,
                                            style: const TextStyle(
                                              color: AppColors.whiteAlmost,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          if (event.tipoEvento != null &&
                                              event.tipoEvento!.isNotEmpty)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.category,
                                                  color: AppColors.yellowPastel,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    event.tipoEvento!,
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.grayLight,
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 4),
                                          if (event.ciudad != null &&
                                              event.ciudad!.isNotEmpty)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: AppColors.yellowPastel,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    event.ciudad!,
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.grayLight,
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 12),
                                          // Action Buttons
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    _showEventFormBottomSheet(
                                                      context,
                                                      event: event,
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.yellowPastel,
                                                    foregroundColor:
                                                        AppColors.black,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 16,
                                                  ),
                                                  label: const Text(
                                                    'Editar',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    _showDeleteConfirmationDialog(
                                                      context,
                                                      event,
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.error,
                                                    foregroundColor:
                                                        AppColors.whiteAlmost,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 16,
                                                  ),
                                                  label: const Text(
                                                    'Eliminar',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showEventFormBottomSheet(context);
              },
              backgroundColor: AppColors.yellowPastel,
              foregroundColor: AppColors.black,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  void _showEventFormBottomSheet(BuildContext context, {EventEntity? event}) {
    final eventBloc = context.read<EventBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: eventBloc,
        child: EventFormBottomSheet(event: event),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, EventEntity event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.grayDark,
        title: const Text(
          '¿Eliminar evento?',
          style: TextStyle(color: AppColors.whiteAlmost),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar el evento "${event.nombreEvento}"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: AppColors.grayLight),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.grayLight),
            ),
          ),
          // Delete Button
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<EventBloc>().add(DeleteEventRequested(event.id));
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
