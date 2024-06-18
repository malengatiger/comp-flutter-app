import 'package:comp_flutter/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:sgela_services/data/sgela_user.dart';
import 'package:sgela_services/sgela_util/ai_initialization_util.dart';
import 'package:sgela_services/sgela_util/dark_light_control.dart';
import 'package:sgela_services/sgela_util/functions.dart';
import 'package:sgela_services/sgela_util/prefs.dart';
import 'package:sgela_services/sgela_util/register_services.dart';
import 'package:sgela_shared_widgets/util/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
late Prefs mPrefs;
const String mx = '🍎🍎🍎 main: ';

SgelaUser? sgelaUser;
Future<void> main() async {
  pp('$mx SgelaAI Chatbot starting ....');
  WidgetsFlutterBinding.ensureInitialized();
  mPrefs = Prefs(await SharedPreferences.getInstance());
  await _performSetup();

  runApp(const MyApp());
}

void dismissKeyboard(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

Future _performSetup() async {
  pp('$mx SgelaAI Chatbot _performSetup ....');

  try {
    var app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    pp('$mx Firebase has been initialized! name: ${app.name}');
    pp('${app.options.asMap}');
    var fbf = FirebaseFirestore.instanceFor(app: app);
    var auth = FirebaseAuth.instanceFor(app: app);
    var gem = await AiInitializationUtil.initGemini();
    await AiInitializationUtil.initOpenAI();
    await registerServices(
        gemini: gem, firebaseFirestore: fbf, firebaseAuth: auth);
    //
  } catch (e, s) {
    pp(e);
    pp(s);
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pp('$mx  ... dismiss keyboard? Tapped somewhere ...');
        dismissKeyboard(context);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sgela Agent',
        theme: _getTheme(context),
        home: const LandingPage(),
      ),
    );
  }
}
ThemeData _getTheme(BuildContext context) {
  var colorIndex = mPrefs.getColorIndex();
  var mode = mPrefs.getMode();
  if (mode == -1) {
    mode = DARK;
  }
  if (mode == DARK) {
    return ThemeData.dark().copyWith(
      primaryColor:
      getColors().elementAt(colorIndex), // Set the primary color
    );
  } else {
    return ThemeData.light().copyWith(
      primaryColor:
      getColors().elementAt(colorIndex), // Set the primary color
    );
  }
}
