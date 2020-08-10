import 'package:spotify/spotify.dart';

/// Different values for sorting a list of tracks and playlists
enum Order {
  /// By Track Name
  name,

  /// By Track Name (reverse)
  nameReverse,

  /// By Track Artist
  artist,

  /// By Track Artists (reverse)
  artistReverse,

  /// By Track Album Name
  album,

  /// By Track Album Name (reverse)
  albumReverse,

  /// By default, as it was retrieved from API
  byDefault,

  /// By default (reverse)
  byDefaultReverse,

  /// By Playlist Name
  playlistName,

  /// By Playlist Name (reverse)
  playlistNameReverse,
}

/// Class that gives the options in the popup menu to sort lists
class ConstantsOrderOptions {
  /// Track Name Text
  static const String TrackName = 'By Track Name';

  /// Track Artist Text
  static const String Artist = 'By Artist';

  /// Track Album Text
  static const String Album = 'By Album';

  /// By Default Text
  static const String ByDefault = 'By Default';

  /// Playlist Name Text
  static const String PlaylistName = 'By Playlist Name';

  /// Options in a list of tracks
  static const List<String> choices = <String>[
    TrackName,
    Artist,
    Album,
    ByDefault,
  ];

  /// Options in a list of playlists
  static const List<String> choicesPL = [
    PlaylistName,
    ByDefault,
  ];
}

/// Sorts two tracks by their names
int orderName(Track a, Track b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase());

/// Sorts two tracks by the first artists name
int orderArtistName(Track a, Track b) =>
    a.artists[0].name.toLowerCase().compareTo(b.artists[0].name.toLowerCase());

/// Sorts two tracks by their album names
int orderAlbumName(Track a, Track b) =>
    a.album.name.toLowerCase().compareTo(b.album.name.toLowerCase());





class TrackBlocEvent {}

class OrderTrackName extends TrackBlocEvent {}
class OrderTrackArtist extends TrackBlocEvent {}
class OrderTrackAlbum extends TrackBlocEvent {}
class OrderTrackDefault extends TrackBlocEvent {}

class OrderPlaylistName extends TrackBlocEvent {}

