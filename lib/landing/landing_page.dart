import 'package:comp_flutter/auth/sgela_user_registration.dart';
import 'package:comp_flutter/auth/user_sign_in.dart';
import 'package:comp_flutter/landing/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sgela_services/data/sgela_user.dart';
import 'package:sgela_services/sgela_util/functions.dart';
import 'package:sgela_services/sgela_util/navigation_util.dart';
import 'package:sgela_services/sgela_util/prefs.dart';
import 'package:sgela_shared_widgets/util/styles.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  SgelaUser? sgelaUser;
  static const mx = 'LandingPage';

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Prefs prefs = GetIt.instance<Prefs>();

  void _checkStatus() async {
    pp('$mx checkStatus starting ...');

    var mAuth = auth.FirebaseAuth.instance;
    sgelaUser = prefs.getUser();
    if (sgelaUser != null) {
      pp('$mx SgelaUser is authed! ${sgelaUser!.toJson()}');
      _navigateToDashboard();
      return;
    }
    pp('$mx checkStatus done, waiting for register or sign in');
  }

  _navigateToSignIn() {
    pp('$mx _navigateToSignIn ... ');
    NavigationUtils.navigateToPage(
        context: context, widget: const UserSignIn());
  }

  _navigateToRegister() {
    pp('$mx _navigateToRegister ... ');
    NavigationUtils.navigateToPage(
        context: context, widget: const SgelaUserRegistration());
  }

  _navigateToDashboard() async {
    pp('$mx _navigateToDashboard ...');
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.of(context).pop();
      NavigationUtils.navigateToPage(
          context: context, widget: const Dashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Landing'),
        // ),
        body: SafeArea(
            child: Stack(
      children: [
        Column(
          children: [
            // Row(children: [
            //   TextButton(onPressed: (){
            //     _navigateToSignIn();
            //   }, child: const Text('Sign In')),
            //   TextButton(onPressed: (){
            //     _navigateToRegister();
            //   }, child: const Text('Register')),
            // ],),
            Expanded(
                child: Image.asset('assets/image11.webp', fit: BoxFit.cover)),
          ],
        ),
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: Card(
            elevation: 8,
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _navigateToSignIn();
                    },
                    child: Text('Sign In',
                        style: myTextStyle(
                            context, Colors.white, 16, FontWeight.normal)),
                  ),
                  TextButton(
                      onPressed: () {
                        _navigateToRegister();
                      },
                      child: Text('Register',
                          style: myTextStyle(
                              context, Colors.white, 16, FontWeight.normal))),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              color: Colors.black26,
              child: Image.asset(
                'assets/sgela_logo_clear.png',
                height: 200,
                width: 200,
              ),
            ))
      ],
    )));
  }
}
