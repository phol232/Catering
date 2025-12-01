import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_with_email.dart';
import '../../features/auth/domain/usecases/login_with_google.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register_with_email.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/events/data/datasources/event_remote_datasource.dart';
import '../../features/events/data/datasources/image_upload_service.dart';
import '../../features/events/data/repositories/event_repository_impl.dart';
import '../../features/events/domain/repositories/event_repository.dart';
import '../../features/events/domain/usecases/create_event.dart';
import '../../features/events/domain/usecases/delete_event.dart';
import '../../features/events/domain/usecases/get_all_events.dart';
import '../../features/events/domain/usecases/update_event.dart';
import '../../features/events/domain/usecases/upload_event_image.dart';
import '../../features/events/presentation/bloc/event_bloc.dart';
import '../../features/quotes/data/datasources/quote_remote_datasource.dart';
import '../../features/quotes/data/repositories/quote_repository_impl.dart';
import '../../features/quotes/domain/repositories/quote_repository.dart';
import '../../features/quotes/domain/usecases/create_quote_request.dart';
import '../../features/quotes/domain/usecases/get_all_quotes.dart';
import '../../features/quotes/domain/usecases/get_quotes_by_client.dart';
import '../../features/quotes/domain/usecases/update_quote_status.dart';
import '../../features/quotes/domain/usecases/add_menu_to_quote.dart';
import '../../features/quotes/domain/usecases/remove_menu_from_quote.dart';
import '../../features/quotes/domain/usecases/get_quote_by_id.dart';
import '../../features/quotes/presentation/bloc/quote_bloc.dart';
import '../../features/menus/data/datasources/menu_remote_datasource.dart';
import '../../features/menus/data/repositories/menu_repository_impl.dart';
import '../../features/menus/domain/repositories/menu_repository.dart';
import '../../features/menus/presentation/bloc/menu_bloc.dart';
import '../../features/payments/data/datasources/stripe_payment_datasource.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/domain/usecases/process_stripe_payment.dart';
import '../../features/payments/presentation/bloc/payment_bloc.dart';
import '../../features/reports/data/datasources/report_remote_datasource.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/reports/domain/usecases/get_metrics.dart';
import '../../features/reports/presentation/bloc/report_bloc.dart';

final getIt = GetIt.instance;

/// Setup dependency injection
/// Registers all dependencies for the application
Future<void> setupDependencies() async {
  // External dependencies
  // Supabase client is already initialized in SupabaseConfig
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(supabaseClient: getIt()),
  );
  getIt.registerLazySingleton<StripePaymentDatasource>(
    () => StripePaymentDatasourceImpl(client: getIt(), supabaseClient: getIt()),
  );
  getIt.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(supabaseClient: getIt()),
  );

  // Services
  getIt.registerLazySingleton<ImageUploadService>(
    () => ImageUploadService(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      remoteDataSource: getIt(),
      imageUploadService: getIt(),
    ),
  );
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(stripeDatasource: getIt()),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases - Auth
  getIt.registerLazySingleton(() => LoginWithEmail(getIt()));
  getIt.registerLazySingleton(() => RegisterWithEmail(getIt()));
  getIt.registerLazySingleton(() => LoginWithGoogle(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));

  // Use cases - Events
  getIt.registerLazySingleton(() => GetAllEvents(getIt()));
  getIt.registerLazySingleton(() => CreateEvent(getIt()));
  getIt.registerLazySingleton(() => UpdateEvent(getIt()));
  getIt.registerLazySingleton(() => DeleteEvent(getIt()));
  getIt.registerLazySingleton(() => UploadEventImage(getIt()));

  // Use cases - Quotes
  getIt.registerLazySingleton(() => CreateQuoteRequest(getIt()));
  getIt.registerLazySingleton(() => GetQuotesByClient(getIt()));
  getIt.registerLazySingleton(() => GetAllQuotes(getIt()));
  getIt.registerLazySingleton(() => UpdateQuoteStatus(getIt()));
  getIt.registerLazySingleton(() => AddMenuToQuote(getIt()));
  getIt.registerLazySingleton(() => RemoveMenuFromQuote(getIt()));
  getIt.registerLazySingleton(() => GetQuoteById(getIt()));

  // Use cases - Payments
  getIt.registerLazySingleton(() => ProcessStripePayment(getIt()));

  // Use cases - Reports
  getIt.registerLazySingleton(() => GetMetrics(getIt()));

  // BLoCs (registered as factories for multiple instances)
  getIt.registerFactory(
    () => AuthBloc(
      loginWithEmail: getIt(),
      registerWithEmail: getIt(),
      loginWithGoogle: getIt(),
      logout: getIt(),
      getCurrentUser: getIt(),
    ),
  );
  getIt.registerFactory(
    () => EventBloc(
      getAllEvents: getIt(),
      createEvent: getIt(),
      updateEvent: getIt(),
      deleteEvent: getIt(),
      uploadEventImage: getIt(),
    ),
  );
  getIt.registerFactory(
    () => QuoteBloc(
      createQuoteRequest: getIt(),
      getQuotesByClient: getIt(),
      getAllQuotes: getIt(),
      updateQuoteStatus: getIt(),
      addMenuToQuote: getIt(),
      removeMenuFromQuote: getIt(),
      getQuoteById: getIt(),
    ),
  );
  getIt.registerFactory(() => MenuBloc(menuRepository: getIt()));
  getIt.registerFactory(() => PaymentBloc(processStripePayment: getIt()));
  getIt.registerFactory(() => ReportBloc(getMetrics: getIt()));
}
