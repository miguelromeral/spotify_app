import 'package:ShareTheMusic/models/home_data.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/my_spotify_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import '../services/local_database.dart';

class ApiBloc extends Bloc<ApiEventBase, MyApi> {
  @override
  MyApi get initialState => MyApi();

  @override
  Stream<MyApi> mapEventToState(ApiEventBase event) async* {
    if (event is UpdateApiEvent) {
      yield MyApi.withInstance(event.newOne);
    }
  }
  
}

class ApiEventBase {}

class UpdateApiEvent extends ApiEventBase {
  SpotifyApi newOne;

  UpdateApiEvent({@required this.newOne});
}