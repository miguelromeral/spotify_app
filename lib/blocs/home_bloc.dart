import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/local_database.dart';

class HomeBloc extends Bloc<HomeEventBase, HomeData> {
  @override
  HomeData get initialState => HomeData();

  @override
  Stream<HomeData> mapEventToState(HomeEventBase event) async* {
    if (event is UpdateFeedHomeEvent) {
      state.updateFeed(event.suggestions);
      yield state;
    }
  }
}

class HomeEventBase {}

class UpdateFeedHomeEvent extends HomeEventBase {
  List<Suggestion> suggestions;

  UpdateFeedHomeEvent({@required this.suggestions});
}