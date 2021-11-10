import 'package:cloud_firestore/cloud_firestore.dart';

createHosp(String collection, hospName, beds, phoneNo, city, pinCode) async {
  await FirebaseFirestore.instance.collection(collection).doc(hospName).set({
    'name': hospName,
    'beds': beds,
    'phoneno': phoneNo,
    'ciy': city,
    'pincode': pinCode
  });
}
