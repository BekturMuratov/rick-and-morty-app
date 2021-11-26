import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty_app/feature/presentation/bloc/search_bloc/search_state.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent,PersonSearchState>{
  PersonSearchBloc(PersonSearchState initialState) : super(initialState);

}