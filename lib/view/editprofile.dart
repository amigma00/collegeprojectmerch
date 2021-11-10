import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(W * 4),
              child: Container(
                padding: EdgeInsets.all(W * 3),
                child: Column(
                  children: const [
                    TextField(
                      decoration: InputDecoration(hintText: "Hospiatl name"),
                    ),


                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
