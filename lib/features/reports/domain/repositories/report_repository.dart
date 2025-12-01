import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/report_metrics.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportMetrics>> getMetrics();
}
