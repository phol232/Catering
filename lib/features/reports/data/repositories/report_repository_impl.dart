import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../domain/entities/report_metrics.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReportMetrics>> getMetrics() async {
    try {
      final metrics = await remoteDataSource.getMetrics();
      return Right(metrics);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
