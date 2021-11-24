import 'dart:convert';

import 'package:rick_and_morty_app/core/error/exception.dart';
import 'package:rick_and_morty_app/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>>getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

final CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList = sharedPreferences.getStringList(CACHED_PERSONS_LIST);
    if(jsonPersonsList!.isNotEmpty){
      return Future.value(jsonPersonsList.map((person) => PersonModel.fromJson(json.decode(person))).toList());
    }else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList = persons.map((person) => json.encode(person.toJson())).toList();

    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);

    print('Person to write cache: ${jsonPersonsList.length}');
    
    return Future.value(jsonPersonsList);
  }
  
}