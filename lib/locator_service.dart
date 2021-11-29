import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rick_and_morty_app/core/platforms/network_info.dart';
import 'package:rick_and_morty_app/feature/data/datasources/person_local_data_source.dart';
import 'package:rick_and_morty_app/feature/data/datasources/person_remote_data_source.dart';
import 'package:rick_and_morty_app/feature/data/repositories/person_repository_impl.dart';
import 'package:rick_and_morty_app/feature/domain/repositories/person_repository.dart';
import 'package:rick_and_morty_app/feature/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty_app/feature/domain/usecases/search_person.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



final sl = GetIt.instance;

Future<void> init()async {
  // Bloc / Cubit
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPerson: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));

  // Repositories
  sl.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl()));

  sl.registerLazySingleton<PersonRemoteDataSource>(() => PersonRemoteDataSourceImpl(
      client: http.Client())
  );
  
  sl.registerLazySingleton<PersonLocalDataSource>(() => PersonLocalDataSourceImpl(
      sharedPreferences: sl())
  );

  //Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final sharedPreferences  =  SharedPreferences.getInstance();
  sl.registerLazySingleton(() async => await sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}