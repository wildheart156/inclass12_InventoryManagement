import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firestore_service.dart';
import 'item.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InventoryPage());
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
      appBar: AppBar(title: const Text('Inventory App')),

      body: StreamBuilder<List<Item>>(
        stream: service.streamItems(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('No items yet.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              return ListTile(
                title: Text(item.name),
                subtitle: Text('Qty: ${item.quantity}'),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => service.deleteItem(item.id!),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

