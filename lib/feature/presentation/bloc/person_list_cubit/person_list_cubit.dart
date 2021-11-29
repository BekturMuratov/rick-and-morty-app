import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/core/error/failure.dart';
import 'package:rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty_app/feature/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/person_list_cubit/person_list_state.dart';


const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';


class PersonListCubit extends Cubit<PersonState>{

  final GetAllPersons getAllPersons;
  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;
  void loadPerson() async{
    if(state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity>[];

    if (currentState is PersonLoaded){
      oldPerson = currentState.personList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));

    failureOrPerson.fold((error) => PersonError(message: _mapFailureToMessage(error)),(character){
      page++;
      final persons = (state as PersonLoading).oldPersonList;
      persons.addAll(character);
      emit(PersonLoaded(persons));
    });}
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }

}