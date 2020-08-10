import 'package:path/path.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

/// Class that manages the connection with the local database in the user device
class LocalDB {
  /// Indicates if the db is already initialized or not
  bool isInit = false;

  /// Local database insstance
  static Future<Database> database;

  LocalDB() {
    // Only init if not yet
    if (database == null || !isInit) {
      init();
    } else {
      isInit = true;
    }
  }

  /// Initializes the database
  Future init() async {
    // Open the database and store the reference.
    print("Openning Database");
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'ShareTheMusic_mr.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          Suggestion.databaseCreateQuery,
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    isInit = true;
  }

// Define a function that inserts suggestions into the database
  Future<bool> insertSuggestion(Suggestion sug) async {
    try {
      // Get a reference to the database.
      final Database db = await database;
      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      var map = sug.toMap();
      //avoid using boolean in local db
      map[Suggestion.fprivate] = (sug.private ? 1 : 0);
      await db.insert(
        Suggestion.databaseName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print("Exception while inserting suggestion: $e");
      return false;
    }
  }

  /// A method that retrieves all the suggestions from the table in the local db.
  Future<List<Suggestion>> suggestions(String mySpotifyUserId) async {
    try {
      // Get a reference to the database.
      final Database db = await database;
      // Query the table for all my suggestions (of the current user loged).
      String whereString = '${Suggestion.fsuserid} = ?';
      final List<Map<String, dynamic>> maps = await db.query(
          Suggestion.databaseName,
          where: whereString,
          whereArgs: [mySpotifyUserId]);
      // Convert the List<Map<String, dynamic> into a List<Suggestion>.
      return List.generate(maps.length, (i) => Suggestion.fromMap(maps[i]));
    } catch (e) {
      print("Exception while getting your suggestions: $e");
      return List();
    }
  }
}
