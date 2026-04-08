import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firestore_service.dart';
import 'item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: InventoryPage());
  }
}


class InventoryPage extends StatelessWidget {
  final FirestoreService service = FirestoreService();

  InventoryPage({super.key});

  void showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final qty = int.tryParse(qtyController.text) ?? 0;


              //adding validation
              if (name.isEmpty || qty <= 0) return;

              await service.addItem(
                Item(name: name, quantity: qty),
              );
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Inventory App'),
    ),
    body: const Center(
      child: Text('Inventory will appear here'),
    ),
  );
}


