import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/get_metrics.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetMetrics getMetrics;

  ReportBloc({required this.getMetrics}) : super(const ReportInitial()) {
    on<ReportLoadMetrics>(_onLoadMetrics);
    on<ReportRefreshMetrics>(_onRefreshMetrics);
  }

  Future<void> _onLoadMetrics(
    ReportLoadMetrics event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoading());
    final result = await getMetrics(NoParams());

    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (metrics) => emit(ReportLoaded(metrics)),
    );
  }

  Future<void> _onRefreshMetrics(
    ReportRefreshMetrics event,
    Emitter<ReportState> emit,
  ) async {
    // Keep current state while refreshing
    final result = await getMetrics(NoParams());

    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (metrics) => emit(ReportLoaded(metrics)),
    );
  }
}
