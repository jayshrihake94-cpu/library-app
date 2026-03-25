import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addBook(Map<String, dynamic> data) async {
    await db.collection('books').add(data);
  }
}