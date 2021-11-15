import 'package:cloud_firestore/cloud_firestore.dart';

createHosp(String collection, hospName, beds, location, phoneNo, city, pinCode,
    double longitude, latitude, bool accha) async {
  await FirebaseFirestore.instance.collection('Hospital').doc(hospName).set({
    'name': hospName,
    'beds': beds,
    'loaction': location,
    'phoneno': phoneNo,
    'ciy': city,
    'pincode': pinCode,
    'longitude': longitude,
    'latitude': latitude,
    'status':accha
  });
}

createShop(String collection, shopName, location, phoneNo, city, pinCode,
    double longitude, latitude, bool accha) async {
  await FirebaseFirestore.instance.collection('Shop').doc(shopName).set({
    'name': shopName,
    'loaction': location,
    'phoneno': phoneNo,
    'ciy': city,
    'pincode': pinCode,
    'longitude': longitude,
    'latitude': latitude,
    'status':accha
  });
}
