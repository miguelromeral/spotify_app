import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/local_database.dart';

/// Bloc that provides us the local db with the device
class LocalDbBloc extends Bloc<LocalDbEventBase, LocalDB> {

  @override
  LocalDB get initialState => LocalDB();

  @override
  Stream<LocalDB> mapEventToState(LocalDbEventBase event) async* {
    if(event is InitLocalDbEvent){
      var newOne = LocalDB();
      await newOne.init();
      yield newOne;
    }
  }
}


/// Main event of the local db bloc
class LocalDbEventBase {}

/// Initializes the localdb in case its not yet
class InitLocalDbEvent extends LocalDbEventBase {}
