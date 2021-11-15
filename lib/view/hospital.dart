import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:collegeprojectmerch/utilities/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class Hospital extends StatefulWidget {
  const Hospital({Key? key}) : super(key: key);

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  //late String status;

  bool _flutter = true;

  TextEditingController hospName = TextEditingController();
  TextEditingController beds = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pinCode = TextEditingController();
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

  String currentAddress = 'My Address';
  late Position currentposition;

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        currentAddress =
            " ${place.name}, ${place.street},${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Hospital"),
        ),
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
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Container(
                                            height: H * 20,
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
                                            "assets/logos/images.png",
                                            scale: 2,
                                          ),
                                        ),
                                  MaterialButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: H*18,
                                            //color: Colors.amber,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                ListTile(
                                                  title: const Text('Camera'),
                                                  leading: const Icon(
                                                      Icons.camera_alt_rounded),
                                                  onTap: () {
                                                    pickImage(
                                                        ImageSource.camera);
                                                  },
                                                ),
                                                ListTile(
                                                  title: const Text('Gallery'),
                                                  leading: const Icon(
                                                      Icons.add_to_photos_rounded),
                                                  onTap: () {
                                                    pickImage(
                                                        ImageSource.gallery);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: "Edit".text.make(),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  "Available Beds : ".text.xl.bold.make(),
                                  HeightBox(H * 2),
                                  SizedBox(
                                    width: W * 14,
                                    height: H * 5,
                                    child: TextFormField(
                                      controller: beds,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      maxLength: 3,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 2)),
                                        counterText: "",
                                        hintText: '---',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          HeightBox(H * 2),
                          SizedBox(
                            height: H * 6,
                            child: TextFormField(
                              controller: hospName,
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
                                hintText: 'Hospital Name',
                              ),
                            ),
                          ),
                          HeightBox(H * 2),
                          SizedBox(
                            height: H * 15,
                            child: TextFormField(
                              maxLines: 5,
                              //maxLength: 10,
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
                                    onPressed: () {
                                      _determinePosition();
                                    },
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
                                hintText: currentAddress,
                              ),
                            ),
                          ),
                          HeightBox(H * 2),
                          SizedBox(
                            height: H * 6,
                            child: TextFormField(
                              controller: phoneNo,
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
                              controller: city,
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
                              controller: pinCode,
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
                  onPressed: () {
                    createHosp(hospName.text, hospName.text, beds.text,currentAddress,
                        phoneNo.text, city.text, pinCode.text,currentposition.longitude,currentposition.latitude,_flutter);
                  },
                  child: "Save".text.make(),
                ),
              ],
            ),
          ),
        ));
  }
}
