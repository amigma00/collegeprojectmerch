import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        appBar: AppBar(
          title: Text("Your Hospital"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              //color: Colors.grey,
              margin: EdgeInsets.all(10),
              child: Container(
                  padding: EdgeInsets.all(W * 2),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center,
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
                      HeightBox(H * 2),
                      Expanded(
                        flex: 0,
                        child: "ABC Hospital".text.xl2.bold.make(),
                      ),
                      HeightBox(H * 2),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Available Beds : ".text.make(),
                          Container(
                            width: W * 14,
                            height: H * 5,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLength: 3,
                              decoration: const InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(),
                                hintText: '---',
                              ),
                            ),
                          ),
                        ],
                      ),
                      HeightBox(H * 2),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.pin_drop_rounded)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.phone)),
                      TextField(
                        decoration: InputDecoration(hintText: "City"),
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "pincode"),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
