import 'package:spotify/spotify.dart';
import '../services/spotifyservice.dart';




class TrackBlocEvent {}

class OrderTrackName extends TrackBlocEvent {}
class OrderTrackArtist extends TrackBlocEvent {}
class OrderTrackAlbum extends TrackBlocEvent {}
class OrderTrackDefault extends TrackBlocEvent {}

