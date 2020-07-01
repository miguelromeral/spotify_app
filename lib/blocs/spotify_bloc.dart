// Al Bloc extenderá del tipo de evento y la clase del estado que guardará
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/blocs/spotify_events.dart';
import 'package:spotify_app/services/spotifyservice.dart';

class SpotifyBloc extends Bloc<SpotifyEventBase, SpotifyService> {
  // Estado inicial
  @override
  SpotifyService get initialState => SpotifyService();

  @override
  Stream<SpotifyService> mapEventToState(SpotifyEventBase event) async* {
    if(event is LoginEvent){
      yield event.service;
    } else {
        throw Exception('oops');
    }

  }
}
