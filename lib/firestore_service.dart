import 'package:cloud_firestore/cloud_firestore.dart';
import 'item.dart';

class FirestoreService {
  final CollectionReference itemsRef = FirebaseFirestore.instance.collection(
    'items',
  );

  // CREATE
  Future<void> addItem(Item item) async {
    await itemsRef.add(item.toMap());
  }

  // READ (REAL-TIME)
  Stream<List<Item>> streamItems() {
    return itemsRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => Item.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  // update option
  Future<void> updateItem(Item item) async {
    await itemsRef.doc(item.id).update(item.toMap());
  }

  // delete option
  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }
}
