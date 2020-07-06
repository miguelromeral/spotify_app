import 'package:path/path.dart';
import 'package:spotify_app/models/suggestion.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalDB {
  Future<Database> database;

  LocalDB() {
    init();
  }

  Future init() async {
    // Open the database and store the reference.
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'spotify_app_mr.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE suggestions(id INTEGER PRIMARY KEY, trackid TEXT, suserid TEXT, fuserid TEXT, text TEXT, date TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

// Define a function that inserts dogs into the database
  Future<void> insertSuggestion(Suggestion sug) async {
    // Get a reference to the database.
    final Database db = await database;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'suggestions',
      sug.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Suggestion>> suggestions() async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('suggestions');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Suggestion(
        trackid: maps[i]['trackid'],
        fuserid: maps[i]['fuserid'],
        suserid: maps[i]['suserid'],
        text: maps[i]['text'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }
}
