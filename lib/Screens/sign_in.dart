import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/Screens/homepage.dart';
import 'package:my_movie_list/Tools/google_sign_in.dart';
import 'package:my_movie_list/widgets.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);
            if (provider.isSigningIn) {
              return buildLoading();
            } else if (snapshot.hasData) {
              return Homepage();
            } else {
              return SignInWidget();
            }
          }
        ),
      )
    );
  }

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      Center(child: CircularProgressIndicator()),
    ],
  );

}
