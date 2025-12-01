import 'package:equatable/equatable.dart';

/// Entity representing app metrics and analytics
class ReportMetrics extends Equatable {
  final RevenueMetrics revenue;
  final OrderMetrics orders;
  final EventMetrics events;
  final ClientMetrics clients;
  final MenuMetrics menus;

  const ReportMetrics({
    required this.revenue,
    required this.orders,
    required this.events,
    required this.clients,
    required this.menus,
  });

  @override
  List<Object?> get props => [revenue, orders, events, clients, menus];
}

class RevenueMetrics extends Equatable {
  final double totalRevenue;
  final double monthRevenue;
  final double yearRevenue;
  final double averageTicket;
  final double monthGrowth;

  const RevenueMetrics({
    required this.totalRevenue,
    required this.monthRevenue,
    required this.yearRevenue,
    required this.averageTicket,
    required this.monthGrowth,
  });

  @override
  List<Object?> get props => [
    totalRevenue,
    monthRevenue,
    yearRevenue,
    averageTicket,
    monthGrowth,
  ];
}

class OrderMetrics extends Equatable {
  final int totalOrders;
  final int pendingOrders;
  final int inProgressOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int monthOrders;
  final double monthGrowth;

  const OrderMetrics({
    required this.totalOrders,
    required this.pendingOrders,
    required this.inProgressOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.monthOrders,
    required this.monthGrowth,
  });

  @override
  List<Object?> get props => [
    totalOrders,
    pendingOrders,
    inProgressOrders,
    completedOrders,
    cancelledOrders,
    monthOrders,
    monthGrowth,
  ];
}

class EventMetrics extends Equatable {
  final int activeEvents;
  final int completedEvents;
  final int yearEvents;
  final double occupancyRate;

  const EventMetrics({
    required this.activeEvents,
    required this.completedEvents,
    required this.yearEvents,
    required this.occupancyRate,
  });

  @override
  List<Object?> get props => [
    activeEvents,
    completedEvents,
    yearEvents,
    occupancyRate,
  ];
}

class ClientMetrics extends Equatable {
  final int totalClients;
  final int newClientsMonth;
  final int recurringClients;
  final double recurringPercentage;

  const ClientMetrics({
    required this.totalClients,
    required this.newClientsMonth,
    required this.recurringClients,
    required this.recurringPercentage,
  });

  @override
  List<Object?> get props => [
    totalClients,
    newClientsMonth,
    recurringClients,
    recurringPercentage,
  ];
}

class MenuMetrics extends Equatable {
  final int availableMenus;
  final int totalDishes;
  final String mostPopularMenu;
  final int mostPopularMenuOrders;

  const MenuMetrics({
    required this.availableMenus,
    required this.totalDishes,
    required this.mostPopularMenu,
    required this.mostPopularMenuOrders,
  });

  @override
  List<Object?> get props => [
    availableMenus,
    totalDishes,
    mostPopularMenu,
    mostPopularMenuOrders,
  ];
}
