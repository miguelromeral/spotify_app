/*import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';

class Files {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _credentialsFile async {
    final path = await _localPath;
    return File('$path/credentials');
  }

static Future<File> writeCounter(SpotifyApiCredentials credentials) async {
  final file = await _credentialsFile;
  return file.writeAsBytes(credentials.);


  
  return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}


  static writeFileCredentials(SpotifyCred) async {}
}
*/