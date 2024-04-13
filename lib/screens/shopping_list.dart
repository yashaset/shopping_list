import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<GroceryItem> groceryList = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: _handleOnAddNewItem, icon: const Icon(Icons.add))
        ],
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}
