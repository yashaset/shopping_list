import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:http/http.dart' as http;

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<GroceryItem> groceryList = [];
  bool _isLoading = true;
  void _loadItems() async {
    final url = Uri.https(
        'shopping-queue-a1233-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> groceryListDTO = json.decode(response.body);
    final List<GroceryItem> loadItemsGroceries = [];
    for (final item in groceryListDTO.entries) {
      final category = categoriesList.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value["category"])
          .value;
      loadItemsGroceries.add(GroceryItem(
          id: item.key,
          category: category,
          name: item.value["name"],
          quantity: item.value["quantity"]));
    }
    setState(() {
      groceryList = loadItemsGroceries;
    });
  }

  void _handleOnAddNewItem() async {
    final groceryItem =
        await Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return const NewItem();
    }));
    if (groceryItem == null) return;
    setState(() {
      groceryList.add(groceryItem);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Text("No items added..");
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (groceryList.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(groceryList[index].id),
          onDismissed: (direction) => {
            setState(() {
              //
            })
          },
          behavior: HitTestBehavior.translucent,
          direction: DismissDirection.horizontal,
          child: ListTile(
            title: Text(groceryList[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryList[index].category.color,
            ),
            trailing: Text(groceryList[index].quantity.toString()),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: _handleOnAddNewItem, icon: const Icon(Icons.add))
        ],
        title: const Text("Shopping List"),
      ),
      body: content,
    );
  }
}
