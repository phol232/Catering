import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class ReportLoadMetrics extends ReportEvent {
  const ReportLoadMetrics();
}

class ReportRefreshMetrics extends ReportEvent {
  const ReportRefreshMetrics();
}
