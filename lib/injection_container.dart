import 'package:get_it/get_it.dart';
import 'data/datasources/firebase_datasource.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => AuthBloc(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FirebaseDataSource>(
    () => FirebaseDataSourceImpl(),
  );
}
