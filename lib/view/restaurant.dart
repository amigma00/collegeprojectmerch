import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegeprojectmerch/utilities/database.dart';
import 'package:collegeprojectmerch/utilities/fireapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class Restaurant extends StatefulWidget {
  const Restaurant({Key? key}) : super(key: key);

  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  //late String status;

  bool _flutter = true;

  TextEditingController restName = TextEditingController();
  TextEditingController table = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController location = TextEditingController();
  File? file;
  String? downloadURL;
  UploadTask? task;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        file = File(image.path);
      });
    } on Exception catch (e) {
      print('some exception in image pickker $e');
    }
  }

  Future uploadImage(File _image) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final fileName = basename(file!.path);
    Reference reference =
        FirebaseStorage.instance.ref().child('Files/$fileName');

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();
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

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var W = context.safePercentWidth;
    var H = context.safePercentHeight;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Restaurant"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            // height: H,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Restaurant')
                        .where('email', isEqualTo: user.email!)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      final abe = snapshot.data!.docs.isEmpty;
                      if (snapshot.hasError) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (abe) {
                        print('abe');
                        return Container(
                          // height: H*,
                          child: Card(
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
                                    //Text(h['name']),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            file != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Container(
                                                      height: H * 15,
                                                      width: W * 20,
                                                      child: Image.file(
                                                        file!,
                                                        scale: 2,
                                                      ),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Image.asset(
                                                      "assets/logos/images.png",
                                                      scale: 4,
                                                    ),
                                                  ),
                                            MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () {
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: H * 18,
                                                      //color: Colors.amber,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: <Widget>[
                                                          ListTile(
                                                            title: const Text(
                                                                'Camera'),
                                                            leading: const Icon(
                                                                Icons
                                                                    .camera_alt_rounded),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              pickImage(
                                                                  ImageSource
                                                                      .camera);
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: const Text(
                                                                'Gallery'),
                                                            leading: const Icon(
                                                                Icons
                                                                    .add_to_photos_rounded),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              pickImage(
                                                                  ImageSource
                                                                      .gallery);
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
                                            "Available Tables : "
                                                .text
                                                .xl
                                                .bold
                                                .make(),
                                            HeightBox(H * 2),
                                            SizedBox(
                                              width: W * 14,
                                              height: H * 5,
                                              child: TextFormField(
                                                controller: table,
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.center,
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                maxLength: 3,
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 2)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2)),
                                                  counterText: "",
                                                  hintText: "---",
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
                                        controller: restName,
                                        //keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(
                                            Icons.local_restaurant_rounded,
                                            color: Colors.blue,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          counterText: "",
                                          hintText: 'Restaurant Name',
                                        ),
                                      ),
                                    ),
                                    HeightBox(H * 2),
                                    SizedBox(
                                      height: H * 10,
                                      child: TextFormField(
                                        controller: location,
                                        maxLines: 5,
                                        //maxLength: 10,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
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
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
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
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: Colors.blue,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
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
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(
                                            Icons.location_city_rounded,
                                            color: Colors.blue,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
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
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        maxLength: 6,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(
                                            Icons.edit_location_rounded,
                                            color: Colors.blue,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          counterText: "",
                                          hintText: 'Pincode',
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        print("expand");
                        return Expanded(
                          child: ListView(
                            children: snapshot.data!.docs.map((h) {
                              restName.text = h['name'];
                              table.text = h['table'];
                              phoneNo.text = h['phoneno'];
                              city.text = h['city'];
                              pinCode.text = h['pincode'];
                              location.text = h['location'];
                              //bool _flutter = h['status'];
                              return Card(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            "Status : ".text.xl2.bold.make(),
                                            if (h['status'] == true)
                                              "On".text.green600.xl.bold.make()
                                            else
                                              "Off".text.red600.xl.bold.make(),
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              alignment: Alignment.topRight,
                                              child: Switch(
                                                value: h['status'],
                                                activeColor: Colors.red,
                                                inactiveTrackColor: Colors.grey,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _flutter = value;
                                                    boolhos(restName.text,
                                                        _flutter);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                h['piclink'] != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        child: Container(
                                                          height: H * 20,
                                                          width: W * 30,
                                                          child: Image.network(
                                                            h['piclink'],
                                                            scale: 2,
                                                          ),
                                                        ),
                                                      )
                                                    : file != null
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            10)),
                                                            child: Container(
                                                              height: H * 20,
                                                              width: W * 30,
                                                              child: Image.file(
                                                                file!,
                                                                scale: 2,
                                                              ),
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            10)),
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: H * 18,
                                                          //color: Colors.amber,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: const Text(
                                                                    'Camera'),
                                                                leading: const Icon(
                                                                    Icons
                                                                        .camera_alt_rounded),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  pickImage(
                                                                      ImageSource
                                                                          .camera);
                                                                },
                                                              ),
                                                              ListTile(
                                                                title: const Text(
                                                                    'Gallery'),
                                                                leading: const Icon(
                                                                    Icons
                                                                        .add_to_photos_rounded),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  pickImage(
                                                                      ImageSource
                                                                          .gallery);
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
                                                "Available Tables : "
                                                    .text
                                                    .xl
                                                    .bold
                                                    .make(),
                                                HeightBox(H * 2),
                                                SizedBox(
                                                  width: W * 14,
                                                  height: H * 5,
                                                  child: TextFormField(
                                                    controller: table,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    maxLength: 3,
                                                    decoration:
                                                        const InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 2)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2)),
                                                      counterText: "",
                                                      hintText: "---",
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
                                            controller: restName,
                                            //keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              prefixIcon: Icon(
                                                Icons.local_restaurant_rounded,
                                                color: Colors.blue,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                              counterText: "",
                                              hintText: 'Restaurant Name',
                                            ),
                                          ),
                                        ),
                                        HeightBox(H * 2),
                                        SizedBox(
                                          height: H * 15,
                                          child: TextFormField(
                                            controller: location,
                                            maxLines: 5,
                                            //maxLength: 10,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
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
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 2)),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2)),
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
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              prefixIcon: Icon(
                                                Icons.phone,
                                                color: Colors.blue,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
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
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              prefixIcon: Icon(
                                                Icons.location_city_rounded,
                                                color: Colors.blue,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
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
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
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
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                              counterText: "",
                                              hintText: 'Pincode',
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }).toList(),
                          ),
                        );
                      } else
                        return CircularProgressIndicator();
                    }),
                MaterialButton(
                  minWidth: W * 30,
                  //height: H * 7,
                  color: Colors.orange,
                  onPressed: () async {
                    uploadImage(file!);
                    print(downloadURL);

                    createRest(
                        restName.text,
                        restName.text,
                        table.text,
                        currentAddress,
                        phoneNo.text,
                        city.text,
                        pinCode.text,
                        user.email!,
                        downloadURL,
                        currentposition.longitude,
                        currentposition.latitude,
                        _flutter);

                    setState(() {});
                  },
                  child: "Save".text.make(),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    setState(() {
      restName.dispose();
      super.dispose();
    });
  }
}
