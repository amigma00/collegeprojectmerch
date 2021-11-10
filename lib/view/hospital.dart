import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Hospital extends StatefulWidget {
  const Hospital({Key? key}) : super(key: key);

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  //late String status;
  bool state = true;
  bool _flutter = true;

  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          //color: Colors.grey,
          margin: EdgeInsets.all(10),
          child: Container(
              padding: EdgeInsets.all(W * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(flex:0,
                        child: "ABC Hospital".text.xl2.bold.make(),
                      ),
                      HeightBox(H * 2),
                      Row(
                        children: [
                          "Available Beds : ".text.make(),
                          Container(
                            width: W * 14,
                            height: H * 5,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLength: 3,
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(),
                                hintText: '---',
                              ),
                            ),
                          ),
                        ],
                      ),
                      HeightBox(H * 2),
                      Container(
                        //color:Colors.grey,
                        width: W*40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.directions)),
                            IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          "Status : ".text.xl.make(),
                          if (_flutter == true)
                            "On".text.green400.xl.bold.make()
                          else
                            "Off".text.red400.xl.bold.make(),
                          Container(
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.topRight,
                            child: Switch(
                              value: _flutter,
                              activeColor: Colors.red,
                              inactiveTrackColor: Colors.grey,
                              onChanged: (bool value) {
                                setState(() {
                                  _flutter = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          "assets/logos/download.jfif",
                          scale: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}
