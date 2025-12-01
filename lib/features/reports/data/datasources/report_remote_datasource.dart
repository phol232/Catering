import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_metrics_model.dart';

abstract class ReportRemoteDataSource {
  Future<ReportMetricsModel> getMetrics();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReportRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ReportMetricsModel> getMetrics() async {
    try {
      // Call the RPC function that aggregates all metrics
      final response = await supabaseClient.rpc('get_dashboard_metrics');

      if (response == null) {
        throw Exception('No data received from metrics');
      }

      return ReportMetricsModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }
}
