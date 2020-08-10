
import 'package:spotify/spotify.dart';

/// Number of different owners in a list of playlists
int differentOwners(List<PlaylistSimple> list) {
  List<String> matches = List();
  for (var t in list) {
    if (!matches.contains(t.owner.id)) {
      matches.add(t.owner.id);
    }
  }
  return matches.length;
}

/// Number of private playlists in a list of playlists
int playlistsPrivate(List<PlaylistSimple> list) {
  int total = 0;
  for (var t in list) {
    if (!t.public) {
      total++;
    }
  }
  return total;
}

/// Print all the artists in the 
String getArtists(Track track) {
  var str = track.artists.map((e) => e.name).toString();
  return str.substring(1, str.length - 1);
}

/// Number of collaborative playlists in a list
int playlistsCollab(List<PlaylistSimple> list) {
  int total = 0;
  for (var t in list) {
    if (t.collaborative) {
      total++;
    }
  }
  return total;
}

/// Number of my playlists in a list
int playlistsMine(List<PlaylistSimple> list, UserPublic me) {
  int total = 0;
  for (var t in list) {
    if (t.owner.id == me.id) {
      total++;
    }
  }
  return total;
}


/// Gets the average popularity of the tracks in the list
int averagePopularity(List<Track> list) {
  if (list.length == 0) return 0;
  int total = 0;
  for (var t in list) {
    total += t.popularity;
  }
  return (total / list.length).truncate();
}

/// Gets the number of different artists in a list of tracks
int differentArtists(List<Track> list) {
  List<String> artists = List();
  for (var t in list) {
    for (var a in t.artists) {
      if (!artists.contains(a.name)) {
        artists.add(a.name);
      }
    }
  }
  return artists.length;
}

/// Gets the number of different albums in the list
int differentAlbums(List<Track> list) {
  List<String> albums = List();
  for (var t in list) {
    if (!albums.contains(t.album.id)) {
      albums.add(t.album.id);
    }
  }
  return albums.length;
}

/// Gets the total amount of duration of the tracks in milliseconds
int totalDuration(List<Track> list) {
  int total = 0;
  for (var t in list) {
    total += t.durationMs;
  }
  return total;
}
