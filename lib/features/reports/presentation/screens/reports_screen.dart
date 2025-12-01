import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/report_metrics.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';

/// Reports screen showing app metrics and analytics
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(const ReportLoadMetrics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.grayDark,
        title: const Text(
          'Reportes',
          style: TextStyle(color: AppColors.whiteAlmost),
        ),
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellowPastel),
            );
          }

          if (state is ReportError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar reportes',
                    style: const TextStyle(
                      color: AppColors.whiteAlmost,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.grayLight),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReportBloc>().add(const ReportLoadMetrics());
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

          if (state is ReportLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReportBloc>().add(const ReportRefreshMetrics());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _buildMetricsContent(state.metrics),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMetricsContent(ReportMetrics metrics) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards
        _buildSummarySection(metrics),
        const SizedBox(height: 24),

        // Revenue Section
        _buildSectionHeader('Ingresos'),
        const SizedBox(height: 12),
        _buildRevenueCards(metrics.revenue),
        const SizedBox(height: 24),

        // Orders Section
        _buildSectionHeader('Pedidos'),
        const SizedBox(height: 12),
        _buildOrdersCards(metrics.orders),
        const SizedBox(height: 24),

        // Events Section
        _buildSectionHeader('Eventos'),
        const SizedBox(height: 12),
        _buildEventsCards(metrics.events),
        const SizedBox(height: 24),

        // Clients Section
        _buildSectionHeader('Clientes'),
        const SizedBox(height: 12),
        _buildClientsCards(metrics.clients),
        const SizedBox(height: 24),

        // Menus Section
        _buildSectionHeader('Menús'),
        const SizedBox(height: 12),
        _buildMenusCards(metrics.menus),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.yellowPastel,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSummarySection(ReportMetrics metrics) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Ingresos',
            value: 'S/ ${metrics.revenue.totalRevenue.toStringAsFixed(0)}',
            icon: Icons.attach_money,
            color: AppColors.success,
            trend:
                '${metrics.revenue.monthGrowth >= 0 ? '+' : ''}${metrics.revenue.monthGrowth.toStringAsFixed(1)}%',
            trendUp: metrics.revenue.monthGrowth >= 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Pedidos Mes',
            value: '${metrics.orders.monthOrders}',
            icon: Icons.shopping_cart,
            color: AppColors.info,
            trend:
                '${metrics.orders.monthGrowth >= 0 ? '+' : ''}${metrics.orders.monthGrowth.toStringAsFixed(1)}%',
            trendUp: metrics.orders.monthGrowth >= 0,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueCards(RevenueMetrics revenue) {
    final now = DateTime.now();
    final monthName = _getMonthName(now.month);
    return Column(
      children: [
        _buildDetailCard(
          title: 'Ingresos del mes',
          value: 'S/ ${revenue.monthRevenue.toStringAsFixed(0)}',
          subtitle: '$monthName ${now.year}',
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Ingresos del año',
          value: 'S/ ${revenue.yearRevenue.toStringAsFixed(0)}',
          subtitle: '${now.year}',
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Ticket promedio',
          value: 'S/ ${revenue.averageTicket.toStringAsFixed(0)}',
          subtitle: 'Por pedido',
          icon: Icons.receipt_long,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }

  Widget _buildOrdersCards(OrderMetrics orders) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSmallMetricCard(
                title: 'Pendientes',
                value: '${orders.pendingOrders}',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallMetricCard(
                title: 'En proceso',
                value: '${orders.inProgressOrders}',
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSmallMetricCard(
                title: 'Completados',
                value: '${orders.completedOrders}',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallMetricCard(
                title: 'Cancelados',
                value: '${orders.cancelledOrders}',
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventsCards(EventMetrics events) {
    return Column(
      children: [
        _buildDetailCard(
          title: 'Eventos activos',
          value: '${events.activeEvents}',
          subtitle: 'Próximos 30 días',
          icon: Icons.event,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Eventos completados',
          value: '${events.completedEvents}',
          subtitle: 'Este año',
          icon: Icons.event_available,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Tasa de ocupación',
          value: '${events.occupancyRate.toStringAsFixed(1)}%',
          subtitle: 'Promedio mensual',
          icon: Icons.pie_chart,
        ),
      ],
    );
  }

  Widget _buildClientsCards(ClientMetrics clients) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSmallMetricCard(
                title: 'Total clientes',
                value: '${clients.totalClients}',
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallMetricCard(
                title: 'Nuevos (mes)',
                value: '${clients.newClientsMonth}',
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Clientes recurrentes',
          value: '${clients.recurringClients}',
          subtitle:
              '${clients.recurringPercentage.toStringAsFixed(1)}% del total',
          icon: Icons.people,
        ),
      ],
    );
  }

  Widget _buildMenusCards(MenuMetrics menus) {
    return Column(
      children: [
        _buildDetailCard(
          title: 'Menús disponibles',
          value: '${menus.availableMenus}',
          subtitle: 'Activos',
          icon: Icons.restaurant_menu,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Platos totales',
          value: '${menus.totalDishes}',
          subtitle: 'En catálogo',
          icon: Icons.fastfood,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          title: 'Menú más popular',
          value: menus.mostPopularMenu,
          subtitle: '${menus.mostPopularMenuOrders} pedidos este mes',
          icon: Icons.star,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? trend,
    bool trendUp = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: trendUp ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend,
                        style: TextStyle(
                          color: trendUp ? AppColors.success : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.whiteAlmost,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: AppColors.grayLight, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.yellowPastel.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.yellowPastel, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.grayLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.whiteAlmost,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.grayLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMetricCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.grayLight, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.whiteAlmost,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
