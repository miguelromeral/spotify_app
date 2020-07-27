import 'package:ShareTheMusic/_shared/animated_background.dart';
import 'package:ShareTheMusic/_shared/screens/error_screen.dart';
import 'package:ShareTheMusic/blocs/spotify_bloc.dart';
import 'package:ShareTheMusic/screens/styles.dart';
import 'package:ShareTheMusic/services/gui.dart';
import 'package:ShareTheMusic/services/spotifyservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class MySettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Delete Your User Info?"),
        content: new Text(
            "Do you really want to delete every data from ShareTheTrack? This action can't be undone"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Sure, Delete"),
            textColor: Colors.white,
            onPressed: () async {
              Navigator.of(context).pop();
              var bloc = BlocProvider.of<SpotifyBloc>(context);
              bloc.add(DeleteInfoEvent(suserid: bloc.state.myUser.id));

  // TODO: ACABAR DE IMPLEMENTAR LA ELIMINACIÓN DE USUARIOS

              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                          body: Center(
                            child: Text('Deleting user...'),
                          ),
                        )),
              );
            },
          ),
          new FlatButton(
            child: new Text("NO, STAY IN THE APP"),
            color: colorSemiBackground,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _SettingsScreenState extends State<MySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotifyBloc, SpotifyService>(
      builder: (context, state) {
        if (state.deletedInfo) {
          return FancyBackgroundApp(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Your data has been deleted successfully, but...',
                            style: styleCardContent,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: ErrorScreen(
                            title: "We're so sorry you leave us.",
                            stringBelow: [
                              "If you change your mind, just sing up again and start from zero!",
                              "And if we did something wrong, please send your feedback to make us improve."
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Container(
          child: SettingsScreen(
            title: "Application Settings",
            children: [
              SettingsGroup(
                title: 'Tracks',
                subtitle: 'Change how the tracks are displayed.',
                children: [
                  SwitchSettingsTile(
                    settingKey: settings_track_popularity,
                    title: 'Show Popularity',
                    enabledLabel:
                        'A percentage will appear in the track info. This value is calculated by Spotify according to'
                        ' most currently played songs.',
                    disabledLabel: 'No popularity measure is shown.',
                    leading: Icon(Icons.people_outline),
                    defaultValue: true,
                  ),
                  SwitchSettingsTile(
                    settingKey: settings_track_duration,
                    title: 'Show Duration',
                    enabledLabel:
                        'Display the duration of the track in the album icon in some screens',
                    disabledLabel: 'No duration displayed',
                    leading: Icon(Icons.timer),
                    defaultValue: true,
                  ),
                  SwitchSettingsTile(
                    settingKey: settings_track_hide_local,
                    title: 'Hide Local Files',
                    enabledLabel:
                        'The tracks that are not in Spotify will be hidden',
                    disabledLabel: 'You will see the local files too',
                    leading: Icon(Icons.cloud_off),
                    defaultValue: false,
                  ),
                ],
              ),
              SettingsGroup(
                title: 'Suggestions',
                subtitle: 'How the app should work with suggestions.',
                children: [
                  SwitchSettingsTile(
                    leading: Icon(Icons.add_comment),
                    settingKey: settings_suggestion_message_enabled,
                    title: 'Default Text For Your Suggestions.',
                    /*onChange: (value) {
                    debugPrint('key-switch-dev-mod: $value');
                  },*/
                    childrenIfEnabled: <Widget>[
                      TextInputSettingsTile(
                        title:
                            'Save a message to load when sharing a new track.',
                        settingKey: settings_suggestion_message,
                        initialValue: '',
                        validator: (String username) {
                          if (username != null && username.length < 140) {
                            return null;
                          }
                          return "The text must be less than 140 characters.";
                        },
                        borderColor: Colors.blueAccent,
                        errorColor: Colors.deepOrangeAccent,
                      ),
                    ],
                  ),
                  SwitchSettingsTile(
                    settingKey: settings_suggestion_private,
                    title: 'Allow anonymous users to see your suggestions',
                    enabledLabel:
                        'Your next suggestions will be visible to any other anonymous users who try the demo of the app.',
                    disabledLabel:
                        "Anonymous users won't see your suggestions. By enabling this option, you'll contribute "
                        "other users who wan't to join the ShareTrackCommunity but they're not sure about singing in.",
                    leading: Icon(Icons.settings_input_antenna),
                    defaultValue: false,
                  ),
                ],
              ),
              SettingsGroup(
                title: 'About',
                //subtitle: 'More info about the app',
                children: [
                  ListTile(
                    title: Text('View GitHub Repository'),
                    subtitle: Text('Take a look to the whole code of the app'),
                    onTap: () {
                      openUrl('https://github.com/miguelromeral/spotify_app');
                    },
                  ),
                  ListTile(
                    title: Text('Report a bug'),
                    subtitle:
                        Text('Report an error or issue in the app on GitHub'),
                    onTap: () {
                      openUrl(
                          'https://github.com/miguelromeral/spotify_app/issues');
                    },
                  ),
                  ListTile(
                    title: Text('Additional Thanks To'),
                    subtitle: Text('Data: Spotify\n'
                        'Backend: Firebase (Firestore)\n'
                        'Icons: app.streamlineicons.com\n'
                        'And last but not least: You for using the app 🙂\n'),
                    /*: () {
                    //  openUrl('https://github.com/miguelromeral/spotify_app/issues');
                  },*/
                  ),
                ],
              ),
              SettingsGroup(
                title: 'Privacy',
                //subtitle: 'More info about the app',
                children: [
                  ListTile(
                    title: Text('Privacy Policy'),
                    subtitle: Text("Read the app's Privacy Policy"),
                    onTap: () {
                      openUrl(
                          'https://github.com/miguelromeral/spotify_app/blob/master/PRIVACY-POLICY.md');
                    },
                  ),
                  /*ListTile(
                    title: Text('Delete My User'),
                    subtitle: Text(
                        "By choosing this option, you will be loged out from the app and all your data stored in "
                        "the servers will be erased. All your followers won't see neither your suggestions nor your spotify user "
                        "when looking for new users. You could sing up again in the app whenever you want in the future, but with "
                        "nothing initialized."),
                    onTap: () {
                      _showDialog(context);
                    },
                  ),*/
                ],
              ),
              ///////////////////////////////////////////////////////////////////
              /*SettingsGroup(
              title: 'Single Choice Settings',
              children: <Widget>[
                SwitchSettingsTile(
                  settingKey: 'key-wifi',
                  title: 'Wi-Fi',

                  //subtitle: 'Wi-Fi allows interacting with the local network or internet via connecting to a W-Fi router',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: Icon(Icons.wifi),
                  onChange: (value) {
                    debugPrint('key-wifi: $value');
                  },
                ),
                CheckboxSettingsTile(
                  settingKey: 'key-blue-tooth',
                  title: 'Bluetooth',
                  //subtitle: 'Bluetooth allows interacting with the near by bluetooth enabled devices',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: Icon(Icons.bluetooth),
                  onChange: (value) {
                    debugPrint('key-blue-tooth: $value');
                  },
                ),
                SwitchSettingsTile(
                  leading: Icon(Icons.developer_mode),
                  settingKey: 'key-switch-dev-mode',
                  title: 'Developer Settings',
                  onChange: (value) {
                    debugPrint('key-switch-dev-mod: $value');
                  },
                  childrenIfEnabled: <Widget>[
                    CheckboxSettingsTile(
                      leading: Icon(Icons.adb),
                      settingKey: 'key-is-developer',
                      title: 'Developer Mode',
                      onChange: (value) {
                        debugPrint('key-is-developer: $value');
                      },
                    ),
                    SwitchSettingsTile(
                      leading: Icon(Icons.usb),
                      settingKey: 'key-is-usb-debugging',
                      title: 'USB Debugging',
                      onChange: (value) {
                        debugPrint('key-is-usb-debugging: $value');
                      },
                    ),
                    SimpleSettingsTile(
                      title: 'Root Settings',
                      subtitle: 'These setting is not accessible',
                      enabled: false,
                    ),
                    SimpleSettingsTile(
                      title: 'Custom Settings',
                      subtitle: 'Tap to execute custom callback',
                      //onTap: () => debugPrint('Snackbar action'),
                    ),
                  ],
                ),
                SimpleSettingsTile(
                  title: 'More Settings',
                  subtitle: 'General App Settings',
                  screen: SettingsScreen(
                    title: "App Settings",
                    children: <Widget>[
                      CheckboxSettingsTile(
                        leading: Icon(Icons.adb),
                        settingKey: 'key-is-developer',
                        title: 'Developer Mode',
                        onChange: (bool value) {
                          debugPrint('Developer Mode ${value ? 'on' : 'off'}');
                        },
                      ),
                      SwitchSettingsTile(
                        leading: Icon(Icons.usb),
                        settingKey: 'key-is-usb-debugging',
                        title: 'USB Debugging',
                        onChange: (value) {
                          debugPrint('USB Debugging: $value');
                        },
                      ),
                    ],
                  ),
                ),
                TextInputSettingsTile(
                  title: 'User Name',
                  settingKey: 'key-user-name',
                  initialValue: 'admin',
                  validator: (String username) {
                    if (username != null && username.length > 3) {
                      return null;
                    }
                    return "User Name can't be smaller than 4 letters";
                  },
                  borderColor: Colors.blueAccent,
                  errorColor: Colors.deepOrangeAccent,
                ),
                TextInputSettingsTile(
                  title: 'password',
                  settingKey: 'key-user-password',
                  obscureText: true,
                  validator: (String password) {
                    if (password != null && password.length > 6) {
                      return null;
                    }
                    return "Password can't be smaller than 7 letters";
                  },
                  borderColor: Colors.blueAccent,
                  errorColor: Colors.deepOrangeAccent,
                ),
                ModalSettingsTile(
                  title: 'Quick setting dialog',
                  subtitle: 'Settings on a dialog',
                  children: <Widget>[
                    CheckboxSettingsTile(
                      settingKey: 'key-day-light-savings',
                      title: 'Daylight Time Saving',
                      enabledLabel: 'Enabled',
                      disabledLabel: 'Disabled',
                      leading: Icon(Icons.timelapse),
                      onChange: (value) {
                        debugPrint('key-day-light-saving: $value');
                      },
                    ),
                    SwitchSettingsTile(
                      settingKey: 'key-dark-mode',
                      title: 'Dark Mode',
                      enabledLabel: 'Enabled',
                      disabledLabel: 'Disabled',
                      leading: Icon(Icons.palette),
                      onChange: (value) {
                        debugPrint('jey-dark-mode: $value');
                      },
                    ),
                  ],
                ),
                ExpandableSettingsTile(
                  title: 'Quick setting 2',
                  subtitle: 'Expandable Settings',
                  children: <Widget>[
                    CheckboxSettingsTile(
                      settingKey: 'key-day-light-savings-2',
                      title: 'Daylight Time Saving',
                      enabledLabel: 'Enabled',
                      disabledLabel: 'Disabled',
                      leading: Icon(Icons.timelapse),
                      onChange: (value) {
                        debugPrint('key-day-light-savings-2: $value');
                      },
                    ),
                    SwitchSettingsTile(
                      settingKey: 'key-dark-mode-2',
                      title: 'Dark Mode',
                      enabledLabel: 'Enabled',
                      disabledLabel: 'Disabled',
                      leading: Icon(Icons.palette),
                      onChange: (value) {
                        debugPrint('key-dark-mode-2: $value');
                      },
                    ),
                  ],
                ),
              ],
            ),
            SettingsGroup(
              title: 'Multiple choice settings',
              children: <Widget>[
                RadioSettingsTile<int>(
                  title: 'Preferred Sync Period',
                  settingKey: 'key-radio-sync-period',
                  values: <int, String>{
                    0: 'Never',
                    1: 'Daily',
                    7: 'Weekly',
                    15: 'Fortnight',
                    30: 'Monthly',
                  },
                  selected: 0,
                  onChange: (value) {
                    debugPrint('key-radio-sync-period: $value');
                  },
                ),
                DropDownSettingsTile<int>(
                  title: 'E-Mail View',
                  settingKey: 'key-dropdown-email-view',
                  values: <int, String>{
                    2: 'Simple',
                    3: 'Adjusted',
                    4: 'Normal',
                    5: 'Compact',
                    6: 'Squizzed',
                  },
                  selected: 2,
                  onChange: (value) {
                    debugPrint('key-dropdown-email-view: $value');
                  },
                ),
              ],
            ),
            ModalSettingsTile(
              title: 'Group Settings',
              subtitle: 'Same group settings but in a dialog',
              children: <Widget>[
                SimpleRadioSettingsTile(
                  title: 'Sync Settings',
                  settingKey: 'key-radio-sync-settings',
                  values: <String>[
                    'Never',
                    'Daily',
                    'Weekly',
                    'Fortnight',
                    'Monthly',
                  ],
                  selected: 'Daily',
                  onChange: (value) {
                    debugPrint('key-radio-sync-settins: $value');
                  },
                ),
                SimpleDropDownSettingsTile(
                  title: 'Beauty Filter',
                  settingKey: 'key-dropdown-beauty-filter',
                  values: <String>[
                    'Simple',
                    'Normal',
                    'Little Special',
                    'Special',
                    'Extra Special',
                    'Bizzar',
                    'Horrific',
                  ],
                  selected: 'Special',
                  onChange: (value) {
                    debugPrint('key-dropdown-beauty-filter: $value');
                  },
                )
              ],
            ),
            ExpandableSettingsTile(
              title: 'Expandable Group Settings',
              subtitle: 'Group of settings (expandable)',
              children: <Widget>[
                RadioSettingsTile<double>(
                  title: 'Beauty Filter',
                  settingKey: 'key-radio-beauty-filter-exapndable',
                  values: <double, String>{
                    1.0: 'Simple',
                    1.5: 'Normal',
                    2.0: 'Little Special',
                    2.5: 'Special',
                    3.0: 'Extra Special',
                    3.5: 'Bizzar',
                    4.0: 'Horrific',
                  },
                  selected: 2.5,
                  onChange: (value) {
                    debugPrint('key-radio-beauty-filter-expandable: $value');
                  },
                ),
                DropDownSettingsTile<int>(
                  title: 'Preferred Sync Period',
                  settingKey: 'key-dropdown-sync-period-2',
                  values: <int, String>{
                    0: 'Never',
                    1: 'Daily',
                    7: 'Weekly',
                    15: 'Fortnight',
                    30: 'Monthly',
                  },
                  selected: 0,
                  onChange: (value) {
                    debugPrint('key-dropdown-sync-period-2: $value');
                  },
                )
              ],
            ),
            SettingsGroup(
              title: 'Other settings',
              children: <Widget>[
                SliderSettingsTile(
                  title: 'Volume',
                  settingKey: 'key-slider-volume',
                  defaultValue: 20,
                  min: 0,
                  max: 100,
                  step: 5,
                  leading: Icon(Icons.volume_up),
                  /*onChangeEnd: (value) {
                    debugPrint('\n===== on change end =====\n'
                        'key-slider-volume: $value'
                        '\n==========\n');
                  },*/
                ),
                ColorPickerSettingsTile(
                  settingKey: 'key-color-picker',
                  title: 'Accent Color',
                  defaultValue: Colors.blue,
                  onChange: (value) {
                    debugPrint('key-color-picker: $value');
                  },
                )
              ],
            ),
            ModalSettingsTile(
              title: 'Other settings',
              subtitle: 'Other Settings in a Dialog',
              children: <Widget>[
                SliderSettingsTile(
                  title: 'Custom Ratio',
                  settingKey: 'key-custom-ratio-slider-2',
                  defaultValue: 2.5,
                  min: 1,
                  max: 5,
                  step: 0.1,
                  leading: Icon(Icons.aspect_ratio),
                  onChange: (value) {
                    debugPrint('\n===== on change =====\n'
                        'key-custom-ratio-slider-2: $value'
                        '\n==========\n');
                  },
                  /*onChangeStart: (value) {
                    debugPrint('\n===== on change start =====\n'
                        'key-custom-ratio-slider-2: $value'
                        '\n==========\n');
                  },
                  onChangeEnd: (value) {
                    debugPrint('\n===== on change end =====\n'
                        'key-custom-ratio-slider-2: $value'
                        '\n==========\n');
                  },*/
                ),
                ColorPickerSettingsTile(
                  settingKey: 'key-color-picker-2',
                  title: 'Accent Picker',
                  defaultValue: Colors.blue,
                  onChange: (value) {
                    debugPrint('key-color-picker-2: $value');
                  },
                )
              ],
            )*/
            ],
          ),
        );
      },
    );
  }
}

final String settings_track_popularity = 'set_track_popularity';
final String settings_track_duration = 'set_track_duration';
final String settings_track_hide_local = 'set_track_hide_local';

final String settings_suggestion_message = 'set_suggestion_message';
final String settings_suggestion_message_enabled =
    'set_suggestion_message_enabled';
final String settings_suggestion_private = 'set_suggestion_private';
