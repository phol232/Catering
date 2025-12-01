import '../../domain/entities/report_metrics.dart';

class ReportMetricsModel extends ReportMetrics {
  const ReportMetricsModel({
    required super.revenue,
    required super.orders,
    required super.events,
    required super.clients,
    required super.menus,
  });

  factory ReportMetricsModel.fromJson(Map<String, dynamic> json) {
    return ReportMetricsModel(
      revenue: RevenueMetricsModel.fromJson(json['revenue']),
      orders: OrderMetricsModel.fromJson(json['orders']),
      events: EventMetricsModel.fromJson(json['events']),
      clients: ClientMetricsModel.fromJson(json['clients']),
      menus: MenuMetricsModel.fromJson(json['menus']),
    );
  }
}

class RevenueMetricsModel extends RevenueMetrics {
  const RevenueMetricsModel({
    required super.totalRevenue,
    required super.monthRevenue,
    required super.yearRevenue,
    required super.averageTicket,
    required super.monthGrowth,
  });

  factory RevenueMetricsModel.fromJson(Map<String, dynamic> json) {
    return RevenueMetricsModel(
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      monthRevenue: (json['month_revenue'] ?? 0).toDouble(),
      yearRevenue: (json['year_revenue'] ?? 0).toDouble(),
      averageTicket: (json['average_ticket'] ?? 0).toDouble(),
      monthGrowth: (json['month_growth'] ?? 0).toDouble(),
    );
  }
}

class OrderMetricsModel extends OrderMetrics {
  const OrderMetricsModel({
    required super.totalOrders,
    required super.pendingOrders,
    required super.inProgressOrders,
    required super.completedOrders,
    required super.cancelledOrders,
    required super.monthOrders,
    required super.monthGrowth,
  });

  factory OrderMetricsModel.fromJson(Map<String, dynamic> json) {
    return OrderMetricsModel(
      totalOrders: json['total_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      inProgressOrders: json['in_progress_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      monthOrders: json['month_orders'] ?? 0,
      monthGrowth: (json['month_growth'] ?? 0).toDouble(),
    );
  }
}

class EventMetricsModel extends EventMetrics {
  const EventMetricsModel({
    required super.activeEvents,
    required super.completedEvents,
    required super.yearEvents,
    required super.occupancyRate,
  });

  factory EventMetricsModel.fromJson(Map<String, dynamic> json) {
    return EventMetricsModel(
      activeEvents: json['active_events'] ?? 0,
      completedEvents: json['completed_events'] ?? 0,
      yearEvents: json['year_events'] ?? 0,
      occupancyRate: (json['occupancy_rate'] ?? 0).toDouble(),
    );
  }
}

class ClientMetricsModel extends ClientMetrics {
  const ClientMetricsModel({
    required super.totalClients,
    required super.newClientsMonth,
    required super.recurringClients,
    required super.recurringPercentage,
  });

  factory ClientMetricsModel.fromJson(Map<String, dynamic> json) {
    return ClientMetricsModel(
      totalClients: json['total_clients'] ?? 0,
      newClientsMonth: json['new_clients_month'] ?? 0,
      recurringClients: json['recurring_clients'] ?? 0,
      recurringPercentage: (json['recurring_percentage'] ?? 0).toDouble(),
    );
  }
}

class MenuMetricsModel extends MenuMetrics {
  const MenuMetricsModel({
    required super.availableMenus,
    required super.totalDishes,
    required super.mostPopularMenu,
    required super.mostPopularMenuOrders,
  });

  factory MenuMetricsModel.fromJson(Map<String, dynamic> json) {
    return MenuMetricsModel(
      availableMenus: json['available_menus'] ?? 0,
      totalDishes: json['total_dishes'] ?? 0,
      mostPopularMenu: json['most_popular_menu'] ?? 'N/A',
      mostPopularMenuOrders: json['most_popular_menu_orders'] ?? 0,
    );
  }
}
