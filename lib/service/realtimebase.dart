
import 'package:firebase_database/firebase_database.dart';

class RealTimeBase{
  FirebaseDatabase? database = FirebaseDatabase(databaseURL:"https://camp-849d5-default-rtdb.firebaseio.com");
  DatabaseReference? reference;
  static String _databaseUrl = "https://tourapp-4594d-default-rtdb.firebaseio.com";
}