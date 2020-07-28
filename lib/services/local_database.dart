import 'package:path/path.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalDB {
  bool isInit = false;
  static Future<Database> database;

  LocalDB() {
    //init();
    if (database == null || !isInit) {
      init();
    } else {
      isInit = true;
    }
  }

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

// Define a function that inserts dogs into the database
  Future<bool> insertSuggestion(Suggestion sug) async {
    try {
      // Get a reference to the database.
      final Database db = await database;
      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      var map = sug.toMap();
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

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Suggestion>> suggestions(String mySpotifyUserId) async {
    try {
      // Get a reference to the database.
      final Database db = await database;
      // Query the table for all The Dogs.
      String whereString = '${Suggestion.fsuserid} = ?';
      final List<Map<String, dynamic>> maps = await db.query(
          Suggestion.databaseName,
          where: whereString,
          whereArgs: [mySpotifyUserId]);
      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Suggestion(
          trackid: maps[i][Suggestion.ftrackid],
          fuserid: maps[i][Suggestion.ffuserid],
          suserid: maps[i][Suggestion.fsuserid],
          text: maps[i][Suggestion.ftext],
          date: DateTime.parse(maps[i][Suggestion.fdate]),
          likes: maps[i][Suggestion.flikes],
          private: (maps[i][Suggestion.fprivate] == 1 ? true : false),
        );
      });
    } catch (e) {
      print("Exception while getting your suggestions: $e");
      return List();
    }
  }
}
