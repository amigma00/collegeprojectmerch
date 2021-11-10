import 'package:collegeprojectmerch/model/signinmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';



class SignupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Center(
          child: Column(children: [
            Text("QC Product Sign in module"),
            ElevatedButton.icon(
              onPressed: () {
                final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googlelogin();
              },
              label: Text("Sign in With Google"),
              icon: FaIcon(FontAwesomeIcons.google),
            )
          ])),
    );
  }
}