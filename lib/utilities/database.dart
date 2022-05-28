import 'package:cloud_firestore/cloud_firestore.dart';

createShop(String collection, shopName, location, phoneNo, city, pinCode, email, piclink,upi,
    double longitude, latitude, bool accha) async {
  await FirebaseFirestore.instance.collection('Shop').doc(shopName).set({
    'name': shopName,
    'location': location,
    'phoneno': phoneNo,
    'city': city,
    'pincode': pinCode,
    'email': email,
    'piclink': piclink,
    'longitude': longitude,
    'latitude': latitude,
    'status': accha,
    'upi':upi
  });
}

createHosp(String collection, hospName, beds, location, phoneNo, city, pinCode,upi,
    email, piclink, double longitude, latitude, bool accha) async {
  await FirebaseFirestore.instance.collection('Hospital').doc(hospName).set({
    'name': hospName,
    'beds': beds,
    'location': location,
    'phoneno': phoneNo,
    'city': city,
    'pincode': pinCode,
    'email': email,
    'piclink': piclink,
    'longitude': longitude,
    'latitude': latitude,
    'status': accha,    'upi':upi
  });
}
createRest(String collection, restName, tables, location, phoneNo, city, pinCode,upi,
    email, piclink, double longitude, latitude, bool accha) async {
  await FirebaseFirestore.instance.collection('Restaurant').doc(restName).set({
    'name': restName,
    'tables': tables,
    'location': location,
    'phoneno': phoneNo,
    'city': city,
    'pincode': pinCode,
    'email': email,
    'piclink': piclink,
    'longitude': longitude,
    'latitude': latitude,
    'status': accha,    'upi':upi
  });
}

boolhos(String hospName, bool accha) async {
  await FirebaseFirestore.instance
      .collection('Hospital')
      .doc(hospName)
      .update({'status': accha});
}

boolres(String restName, bool accha) async {
  await FirebaseFirestore.instance
      .collection('Restaurant')
      .doc(restName)
      .update({'status': accha});
}

boolsho(String shopName, bool accha) async {
  await FirebaseFirestore.instance
      .collection('Shop')
      .doc(shopName)
      .update({'status': accha});
}

// createTempHosp()async{String
