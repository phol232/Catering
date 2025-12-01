import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/report_metrics.dart';
import '../repositories/report_repository.dart';

class GetMetrics implements UseCase<ReportMetrics, NoParams> {
  final ReportRepository repository;

  GetMetrics(this.repository);

  @override
  Future<Either<Failure, ReportMetrics>> call(NoParams params) async {
    return await repository.getMetrics();
  }
}
