import 'package:ShareTheMusic/services/gui.dart';
import 'package:flutter/material.dart';
import 'package:search_app_bar/search_bloc.dart';

/// Search Text Field in the screen with list. Allows the user to filter using a criteria
class SearchTextField extends StatefulWidget {
  /// List of items
  final List list;
  /// Text Controller of the text field
  final TextEditingController controller;
  /// Indicator if the field is empty
  final bool textEmpty;
  /// Hint of the text field
  final String hint;
  /// SearchBloc that manages the search criteria
  final SearchBloc searchbloc;

  SearchTextField(
      {this.list, this.controller, this.textEmpty, this.hint, this.searchbloc});

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return (widget.list != null || widget.list.isNotEmpty
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Use all the space for the textfield, but when the
              /// delete icon is shown, let him a little space at the end
              Expanded(
                flex: 1,
                child: TextField(
                  // Use the controller to know when the field is empty
                  controller: widget.controller,
                  showCursor: true,
                  // Go to the search bloc to use the filters when typped something
                  onChanged: widget.searchbloc.onSearchQueryChanged,

                  decoration: getSearchDecoration(widget.hint),
                ),
              ),

              /// No space allowed to the delete icon but the necessary
              Expanded(
                flex: 0,
                // Only show when the textfield is not empty
                child: (widget.textEmpty
                    ? Container()
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Clear the entry and reset the criteria to show all the initial list again
                          widget.controller.clear();
                          widget.searchbloc.onSearchQueryChanged('');
                        },
                      )),
              ),
            ],
          )
        : Container());
  }
}
