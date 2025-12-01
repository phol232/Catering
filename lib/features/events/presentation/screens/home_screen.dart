import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import 'event_detail_screen.dart';

/// Home screen for browsing public events
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;

    return BlocProvider(
      create: (context) => getIt<EventBloc>()..add(LoadAllEvents()),
      child: Scaffold(
        backgroundColor: AppColors.black,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (isAuthenticated) {
              _showQuoteRequestDialog(context);
            } else {
              context.go('/auth/login');
            }
          },
          backgroundColor: AppColors.yellowPastel,
          foregroundColor: AppColors.black,
          icon: const Icon(Icons.request_quote),
          label: const Text(
            'Solicitar Cotización',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.black,
          title: const Text(
            'CaterPro',
            style: TextStyle(
              color: AppColors.yellowPastel,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (isAuthenticated)
              IconButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, color: AppColors.yellowPastel),
                tooltip: 'Cerrar Sesión',
              )
            else
              TextButton(
                onPressed: () {
                  context.go('/auth/login');
                },
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: AppColors.yellowPastel,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: BlocBuilder<EventBloc, EventState>(
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
                  ],
                ),
              );
            }

            if (state is EventsLoaded) {
              if (state.events.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event,
                        size: 64,
                        color: AppColors.yellowPastel,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bienvenido a CaterPro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteAlmost,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No hay eventos disponibles en este momento',
                        style: TextStyle(color: AppColors.grayLight),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Sort events by date
              final sortedEvents = List<EventEntity>.from(state.events)
                ..sort((a, b) => b.fecha.compareTo(a.fecha));

              // Get featured events (first 4)
              final featuredEvents = sortedEvents.take(4).toList();

              // Get top events for carousel (remaining events)
              final topEvents = sortedEvents.length > 4
                  ? sortedEvents.skip(4).toList()
                  : [];

              // Get popular categories
              final categoryCount = <String, int>{};
              for (var event in sortedEvents) {
                if (event.tipoEvento != null && event.tipoEvento!.isNotEmpty) {
                  categoryCount[event.tipoEvento!] =
                      (categoryCount[event.tipoEvento!] ?? 0) + 1;
                }
              }
              final popularCategories = categoryCount.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Banner (full width)
                    _HeroBanner(),
                    const SizedBox(height: 32),

                    // Popular Categories Section
                    if (popularCategories.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.category,
                              color: AppColors.yellowPastel,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Categorías Populares',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteAlmost,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: popularCategories.take(5).length,
                          itemBuilder: (context, index) {
                            final category = popularCategories[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < popularCategories.length - 1
                                    ? 16
                                    : 0,
                              ),
                              child: _CategoryCard(
                                category: category.key,
                                count: category.value,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Featured Events Section
                    if (featuredEvents.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.yellowPastel,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Eventos Destacados',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteAlmost,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: featuredEvents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < featuredEvents.length - 1
                                    ? 16
                                    : 0,
                              ),
                              child: _FeaturedEventCard(
                                event: featuredEvents[index],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Top Events Carousel
                    if (topEvents.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: AppColors.yellowPastel,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Más Eventos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteAlmost,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: topEvents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < topEvents.length - 1 ? 16 : 0,
                              ),
                              child: _CityEventCard(event: topEvents[index]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showQuoteRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.grayDark,
        title: Row(
          children: [
            const Icon(
              Icons.request_quote,
              color: AppColors.yellowPastel,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Solicitar Cotización',
              style: TextStyle(color: AppColors.whiteAlmost, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Para solicitar una cotización personalizada, por favor contáctanos:',
              style: TextStyle(color: AppColors.grayLight, fontSize: 14),
            ),
            const SizedBox(height: 20),
            _ContactOption(
              icon: Icons.email,
              label: 'Email',
              value: 'info@caterpro.com',
              onTap: () {
                // TODO: Abrir email
              },
            ),
            const SizedBox(height: 12),
            _ContactOption(
              icon: Icons.phone,
              label: 'Teléfono',
              value: '+57 300 123 4567',
              onTap: () {
                // TODO: Abrir teléfono
              },
            ),
            const SizedBox(height: 12),
            _ContactOption(
              icon: Icons.chat,
              label: 'WhatsApp',
              value: 'Enviar mensaje',
              onTap: () {
                // TODO: Abrir WhatsApp
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cerrar',
              style: TextStyle(color: AppColors.grayLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.grayDark,
        title: const Text(
          '¿Cerrar Sesión?',
          style: TextStyle(color: AppColors.whiteAlmost),
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: TextStyle(color: AppColors.grayLight),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.grayLight),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go('/auth/login');
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero banner widget (full width)
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.yellowPastel, Color(0xFFFFD54F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              Icons.celebration,
              size: 180,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡Bienvenido a CaterPro!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encuentra el catering perfecto\npara tu evento',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.black,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.yellowPastel,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Explorar Eventos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Featured event card widget
class _FeaturedEventCard extends StatelessWidget {
  final EventEntity event;

  const _FeaturedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: AppColors.grayDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                    ? Image.network(
                        event.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.black,
                            child: const Center(
                              child: Icon(
                                Icons.event,
                                color: AppColors.grayLight,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.black,
                        child: const Center(
                          child: Icon(
                            Icons.event,
                            color: AppColors.grayLight,
                            size: 48,
                          ),
                        ),
                      ),
              ),
            ),
            // Event Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (event.ciudad != null && event.ciudad!.isNotEmpty)
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
                              color: AppColors.grayLight,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// City event card widget
class _CityEventCard extends StatelessWidget {
  final EventEntity event;

  const _CityEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.grayDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                    ? Image.network(
                        event.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.black,
                            child: const Center(
                              child: Icon(
                                Icons.event,
                                color: AppColors.grayLight,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.black,
                        child: const Center(
                          child: Icon(
                            Icons.event,
                            color: AppColors.grayLight,
                            size: 36,
                          ),
                        ),
                      ),
              ),
            ),
            // Event Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.nombreEvento,
                    style: const TextStyle(
                      color: AppColors.whiteAlmost,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (event.tipoEvento != null && event.tipoEvento!.isNotEmpty)
                    Text(
                      event.tipoEvento!,
                      style: const TextStyle(
                        color: AppColors.grayLight,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category card widget
class _CategoryCard extends StatelessWidget {
  final String category;
  final int count;

  const _CategoryCard({required this.category, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.grayDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.yellowPastel.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(category),
            color: AppColors.yellowPastel,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            category,
            style: const TextStyle(
              color: AppColors.whiteAlmost,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$count eventos',
            style: const TextStyle(color: AppColors.grayLight, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('boda')) return Icons.favorite;
    if (lower.contains('cumpleaños') || lower.contains('cumpleano'))
      return Icons.cake;
    if (lower.contains('corporativo')) return Icons.business;
    if (lower.contains('graduación') || lower.contains('graduacion'))
      return Icons.school;
    return Icons.event;
  }
}

/// Contact option widget for quote request dialog
class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.yellowPastel.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yellowPastel.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.yellowPastel, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.grayLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.whiteAlmost,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.grayLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
