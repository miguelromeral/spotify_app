import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_app_bar/searcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:ShareTheMusic/blocs/spotify_events.dart';
import 'package:ShareTheMusic/models/following.dart';
import 'package:ShareTheMusic/models/suggestion.dart';
import 'package:ShareTheMusic/services/firestore_db.dart';
import 'package:ShareTheMusic/services/firebase_auth.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:ShareTheMusic/services/password_generator.dart';
import 'package:rxdart/subjects.dart';

class FollowingBloc extends Bloc<FollowingBlocEventBase, List<Following>>
    implements Searcher<Following> {
  List<Following> initialList;
  //List<Following> originalList = new List();
  final _filteredData = BehaviorSubject<List<Following>>();
  Order _order = Order.name;

  FollowingBloc(List<Following> list) {
    initialList = list;
    //originalList = list;
    //copyList(list);
    _filteredData.add(initialList);
  }
/*
  Future copyList(List<Following> list) async {
    if (list != null) {
      originalList.clear();
      for (var t in list) {
        originalList.add(t);
      }
    }
  }
*/
  Stream<List<Following>> get filteredData => _filteredData.stream;

  @override
  get onDataFiltered => _filteredData.add;

  @override
  List<Following> get data => initialList;

  @override
  List<Following> get initialState => List();

  @override
  Stream<List<Following>> mapEventToState(FollowingBlocEventBase event) async* {
    if (event is OrderUsersNameEvent) {
      await _choiceAction(Order.name);
      yield initialList;
    } else if (event is OrderUsersIddEvent) {
      await _choiceAction(Order.id);
      yield initialList;
    }
  }

  Future _choiceAction(Order choice) async {
    if (choice == Order.name) {
      _order = _order == Order.name ? Order.nameReverse : Order.name;
    } else if (choice == Order.id) {
      _order = _order == Order.id ? Order.idReverse : Order.id;
    }
    //list = _setOrder(list);

    initialList = _setOrder(initialList);
    print("New Order:");
    int i = 1;
    for(var f in initialList){
      print('$i - ${f.name}');
      i++;
    }
    _filteredData.add(initialList);
  }

  List<Following> _setOrder(List<Following> list) {
    switch (_order) {
      case Order.name:
        list.sort((a, b) => _orderName(a, b));
        break;
      case Order.nameReverse:
        list.sort((a, b) => _orderName(b, a));
        break;
      case Order.id:
        list.sort((a, b) => _orderId(a, b));
        break;
      case Order.idReverse:
        list.sort((a, b) => _orderId(b, a));
        break;
      
    }
    return list;
  }
}

int _orderName(Following a, Following b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase());
int _orderId(Following a, Following b) =>
    a.suserid.toLowerCase().compareTo(b.suserid.toLowerCase());

enum Order {
  name,
  nameReverse,
  id,
  idReverse,
}

class ConstantsOrderOptionsFollowing {
  static const String FollowingName = 'By Name';
  static const String FollowingId = 'By ID';

  static const List<String> choices = <String>[
    FollowingName,
    FollowingId,
  ];
}

class FollowingBlocEventBase {}

class OrderUsersNameEvent extends FollowingBlocEventBase {}

class OrderUsersIddEvent extends FollowingBlocEventBase {}
