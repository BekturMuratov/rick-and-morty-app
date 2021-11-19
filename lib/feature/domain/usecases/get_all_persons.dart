import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/core/error/failure.dart';
import 'package:rick_and_morty_app/core/usecases/usecase.dart';
import 'package:rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty_app/feature/domain/repositories/person_repository.dart';
import 'package:meta/meta.dart';

class GetAllPersons extends UseCase<List<PersonEntity>,PagePersonParams> {
  final PersonRepository personRepository;

  GetAllPersons(this.personRepository);

  Future<Either<Failure,List<PersonEntity>>> call(PagePersonParams params) async{
    return personRepository.getAllPersons(params.page);
  }
}

class PagePersonParams extends Equatable{
  final int page;

  PagePersonParams({required this.page});

  @override
  List<Object?> get props => throw UnimplementedError();
}