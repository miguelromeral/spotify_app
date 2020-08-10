import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc with the data of the home screen with the list of feed
class HomeBloc extends Bloc<HomeEventBase, HomeData> {
  @override
  HomeData get initialState => HomeData();

  @override
  Stream<HomeData> mapEventToState(HomeEventBase event) async* {
    if (event is UpdateFeedHomeEvent) {
      if (event.suggestions != null) state.updateFeed(event.suggestions);
      yield state;
    }
  }

  dipose() {
    state.dispose();
  }
}

/// Base event for the home bloc
class HomeEventBase {}

/// Updates the list of suggestions to show in the home screen.
class UpdateFeedHomeEvent extends HomeEventBase {
  /// New list of suggestions
  List<Suggestion> suggestions;

  UpdateFeedHomeEvent({@required this.suggestions});
}
