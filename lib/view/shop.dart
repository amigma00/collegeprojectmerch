
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on Exception catch (e) {
      print('some exception in image pickker $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(
appBar: AppBar(title: Text("Your Shop"),),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.grey[350],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                //color: Colors.grey,
                margin: EdgeInsets.all(W * 4),
                child: Container(
                    padding: EdgeInsets.all(W * 2),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Status : ".text.xl2.bold.make(),
                            if (_flutter == true)
                              "On".text.green600.xl.bold.make()
                            else
                              "Off".text.red600.xl.bold.make(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                image != null
                                    ? ClipRRect(borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                  child: Container(  height: H * 20,
                                    width: W * 30,
                                    child: Image.file(
                                      image!,
                                      scale: 2,

                                    ),
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.asset(
                                    "assets/images.png",
                                    scale: 2,
                                  ),
                                ),
                                MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    pickImage(ImageSource.camera);
                                  },
                                  child: "Edit".text.make(),
                                )
                              ],
                            ),

                          ],
                        ),
                        HeightBox(H * 2),
                        SizedBox(
                          height: H * 6,
                          child: TextFormField(
                            //keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              counterText: "",
                              hintText: 'Shop Name',
                            ),
                          ),
                        ),
                        HeightBox(H * 2),
                        SizedBox(
                          height: H * 6,
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.eleven_mp,
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.pin_drop_rounded,
                                    color: Colors.blue,
                                  )),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              counterText: "",
                              hintText: '         Location',
                            ),
                          ),
                        ),
                        HeightBox(H * 2),
                        SizedBox(
                          height: H * 6,
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              counterText: "",
                              hintText: 'Phone Number',
                            ),
                          ),
                        ),
                        HeightBox(H * 2),
                        SizedBox(
                          height: H * 6,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.location_city_rounded,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              counterText: "",
                              hintText: 'City',
                            ),
                          ),
                        ),
                        HeightBox(H * 2),
                        SizedBox(
                          height: H * 6,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.edit_location_rounded,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              counterText: "",
                              hintText: 'Pincode',
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              MaterialButton(
                minWidth: W * 30,
                //height: H * 7,
                color: Colors.orange,
                onPressed: () {},
                child: "Save".text.make(),
              ),
            ],
          ),
        ),
      ));

  }
}