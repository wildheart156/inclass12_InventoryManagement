class Item {
  String? id;
  String name;
  int quantity;

  Item({this.id, required this.name, required this.quantity});

  // Convert object into Firestore map
  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity};
  }

  // Convert Firestore into object
  factory Item.fromMap(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}
