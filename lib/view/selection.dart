import 'package:collegeprojectmerch/view/hospital.dart';
import 'package:collegeprojectmerch/view/shop.dart';
import 'package:collegeprojectmerch/view/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/extensions/string_ext.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: W * 30,
              height: H * 7,
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Hospital(),
                  ),
                );
              },
              child: "Hospital".text.make(),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              minWidth: W * 30,
              height: H * 7,
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Shop(),
                  ),
                );
              },
              child: "Shop".text.make(),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              minWidth: W * 30,
              height: H * 7,
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Restaurant(),
                  ),
                );
              },
              child: "Restaurant".text.make(),
            ),
          ],
        ),
      ),
    );
  }
}
