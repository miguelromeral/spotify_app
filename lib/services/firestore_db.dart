import 'package:ShareTheMusic/screens/settings_screen.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/notifications.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';

/// Instance of the Firestore service, managing the connection between the database and the app
class FirestoreService {
  /// Spotify User ID of the current user loged
  final String spotifyUserID;

  /// Firebase User ID of the current user loged
  final String firebaseUserID;

  FirestoreService({this.spotifyUserID, this.firebaseUserID});

  /// Collection Reference of the suggestions documents in Firestore
  final CollectionReference cSuggestions =
      Firestore.instance.collection("suggestions");

  /// Collection Reference of the following documents in Firestore
  final CollectionReference cFollowing =
      Firestore.instance.collection("following");

  /// *******************************************
  ///
  /// SUGGESTIONS
  ///
  ///********************************************

  /// Gets a list of suggestion from a QuerySnapshot result of a query
  List<Suggestion> _suggestionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Suggestion.fromDocumentSnapshot(doc);
    }).toList();
  }

  /// Updates the current suggestion of an user
  Future<Suggestion> updateUserData(
      String spotifyuserid, String trackid, String text) async {
    Suggestion sug = Suggestion(
        trackid: trackid,
        date: DateTime.now(),
        fuserid: firebaseUserID,
        likes: 0,
        private: Settings.getValue<bool>(settingsSuggestionPrivate, false),
        suserid: spotifyuserid,
        text: text);

    var map = sug.toMap();
    await cSuggestions.document(spotifyuserid).setData(map);
    return sug;
  }

  /// A user votes for this suggestion
  Future likeSuggestion(Suggestion suggestion) async {
    // Avoid a user to vote for their own suggestion
    if (firebaseUserID == suggestion.fuserid ||
        spotifyUserID == suggestion.suserid ||
        suggestion.reference == null) return null;

    // Get the latest count of likes, not the likes that the app has in this moment
    var latest = await getSuggestion(suggestion.suserid);

    return await suggestion.reference.updateData(<String, dynamic>{
      Suggestion.flikes: latest.likes + 1,
    });
  }

  /// Retrieve the current user suggestion
  Future<Suggestion> getMySuggestion() async {
    return await getSuggestion(spotifyUserID);
  }

  /// Get the latest suggestion of an user
  Future<Suggestion> getSuggestion(String suserid) async {
    try {
      return Suggestion.fromDocumentSnapshot(
          await cSuggestions.document(suserid).get());
    } catch (err) {
      print("error while getting suggestion: $err");
      return null;
    }
  }

  /// Get the list of suggestions for the users this user is following (aka the feed)
  Future<List<Suggestion>> getsuggestions() async {
    try {
      // Get who we are following first
      var fol = await getMyFollowing();
      var list = fol.usersList;
      // Show our suggestion too
      list.add(spotifyUserID);
      // Retrieve only the necessary suggestion.
      return cSuggestions
          .where(Suggestion.fsuserid, whereIn: list)
          .getDocuments()
          .then((QuerySnapshot value) {
        // Parse the suggestion snapshot
        return _suggestionListFromSnapshot(value);
      }).catchError((onError) {
        print("Error: $onError");
        return List();
      });
    } catch (err) {
      print("error while getting stream: $err");
      return List();
    }
  }

  /// Retrieve all the suggestions who users marked as visible to anonymous users
  Future<List<Suggestion>> getPublicSuggestions() async {
    try {
      return cSuggestions
          .where(Suggestion.fprivate, isEqualTo: true)
          .getDocuments()
          .then((QuerySnapshot value) {
        return _suggestionListFromSnapshot(value);
      }).catchError((onError) {
        print("Error: $onError");
        return List();
      });
    } catch (err) {
      print("error while getting stream: $err");
      return List();
    }
  }

  /// Get all the suggestions in a stream
  Stream<List<Suggestion>> get suggestions {
    return cSuggestions.snapshots().map(_suggestionListFromSnapshot);
  }

  /// A user votes for a suggestion of a different user
  static Future vote(BuildContext context, SpotifyService state,
      Suggestion suggestion, Track track) async {
    if (state.demo) {
      showMyDialog(context, "You can't Vote Songs in DEMO",
          "Please, log in with Spotify if you want to vote for this song.");
    } else {
      if (!state.firebaseUserIdEquals(suggestion.fuserid)) {
        await state.likeSuggestion(suggestion);

        UpdatedFeedNotification().dispatch(context);

        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('You liked "${track.name}"!')));
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('You Can Not Vote For Your Own Song.')));
      }
    }
  }

  /// *******************************************
  ///
  /// FOLLOWING
  ///
  ///********************************************

  /// Search all the users in the database (collection following) that
  /// has this query in their display name
  Future<List<Following>> searchFollowing(String query) async {
    return cFollowing
        .where(Following.fname, isGreaterThanOrEqualTo: query)
        .getDocuments()
        .then((QuerySnapshot value) => _followingListFromSnapshot(value));
  }

  /// Get all following info for the current user
  Future<Following> getMyFollowing() async {
    return getFollowingBySpotifyUserID(spotifyUserID);
  }

  /// Get following info for the user specified
  Future<Following> getFollowingBySpotifyUserID(String suserid) async {
    return Following.fromDocumentSnapshot(
        await cFollowing.document(suserid).get());
  }

  /// Update the display name in the following info
  Future<bool> updateDisplayName(UserPublic me) async {
    try {
      var mine = await getMyFollowing();
      mine.reference.updateData(<String, dynamic>{
        Following.fname: me.displayName,
      });
      return true;
    } catch (e) {
      print("Error when adding following: $e");
    }
    return false;
  }

  /// Add to this following the next spotify user id
  Future<bool> addFollowing(Following fol, String suserid) async {
    try {
      fol.concatenateUser(suserid);
      // Avoid follow users who are not in the app yet
      Following toFollow = await getFollowingBySpotifyUserID(suserid);
      if (toFollow != null) {
        await fol.reference.updateData(<String, dynamic>{
          Following.fusers: fol.users,
        });
        return true;
      }
    } catch (e) {
      print("Error when adding following: $e");
    }
    return false;
  }

  /// Add to the current following user the next spotify user id
  Future<bool> addFollowingByUserId(String suserid) async {
    Following fol = await getMyFollowing();
    return await addFollowing(fol, suserid);
  }

  /// Deletes a spotify user from the list of following
  Future removeFollowing(Following fol, String suserid) async {
    fol.removeUser(suserid);
    return await fol.reference.updateData(<String, dynamic>{
      Following.fusers: fol.users,
    });
  }

  /// Creates the following info the first time, when the user is being registered
  Future initializeFollowing() async {
    Following init = Following(fuserid: firebaseUserID, suserid: spotifyUserID);
    init.concatenateUser(spotifyUserID);
    var data = init.toMap();
    return await cFollowing.document(spotifyUserID).setData(data);
  }

  /// Get a list of following given the query snapshot
  List<Following> _followingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Following.fromDocumentSnapshot(doc);
    }).toList();
  }

  /// Get all the followings of the app in a stream
  Stream<List<Following>> get following {
    return cFollowing.snapshots().map(_followingListFromSnapshot);
  }

  /// Get the list of following for the users who are currently following this spotify user id
  Future<List<Following>> getFollowers(String spotifyUserId) async {
    var all = await cFollowing.getDocuments().then(_followingListFromSnapshot);
    List<Following> total = List();
    for (var f in all) {
      if (f.suserid != spotifyUserId && f.users.contains(spotifyUserId)) {
        total.add(f);
      }
    }
    return total;
  }

  /// Delete the user info in the app.
  ///
  ///
  /// TBD
  ///
  ///
  Future<bool> deleteUserInfo(String suserid) async {
    try {
      await Future.delayed(Duration(seconds: 10));
      print("Deleted Info $suserid!");
      return true;
    } catch (e) {
      print("Problem while deleting info: $e");
      return false;
    }
  }
}
