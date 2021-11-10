
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  bool state = true;
  bool _flutter = true;
  var color = Colors.red;

  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Card(
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
          Container(
            child: Card(
              elevation: 10,
              //color: Colors.grey,
              margin: EdgeInsets.all(W*3),
              child: Container(
                padding: EdgeInsets.all(W * 2),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(

                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Grocery Shop".text.xl2.bold.make(),
                        HeightBox(H * 11),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.directions)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.phone)),
                          ],
                        )
                      ],
                    ),
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            "Status : ".text.xl.make(),
                            if (_flutter == true)
                              "On".text.xl.green400.bold.make()
                            else
                              "Off".text.xl.red400.bold.make(),
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
                        HeightBox(H*2),

                        ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            "assets/logos/grocery.jpg",
                            scale: 1.5,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}