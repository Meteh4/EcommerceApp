import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shoptral1/Screens/My_Orders_Screen.dart';
import 'package:shoptral1/db/Database%20Helper.dart';
import 'package:shoptral1/db/Order_Helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart.db');
    final Database database = await openDatabase(path, version: 1);
    final List<Map<String, dynamic>> items = await database.query('cart_items');
    setState(() {
      cartItems = items;
    });
    await database.close();
  }

  Future<void> removeItemFromCart(int? itemId) async {
    if (itemId != null) {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'cart.db');
      final Database database = await openDatabase(path, version: 1);
      await database.delete('cart_items', where: 'id = ?', whereArgs: [itemId]);
      setState(() {
        cartItems.removeWhere((item) => item['id'] == itemId);
      });
      await database.close();
    }
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += (item['price'] ?? 0) * (item['quantity'] ?? 0);
    }
    return totalPrice;
  }

  Future<void> _checkout() async {

    List<Map<String, dynamic>> orderItems = List.from(cartItems);
    await OrderHelper.addOrder(orderItems as Map<String, dynamic>);
    setState(() {
      cartItems.clear();
    });
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Sipariş başarıyla tamamlandı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAD3C8),
      body: cartItems.isEmpty
          ?  Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),

            child: Center(
                child: Image.asset('assets/images/sepet.png'),
      ),
          )
          : Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
            child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
            final item = cartItems[index];
            Widget leadingWidget;
            if (item['image'] != null && item['image'] is String) {
              leadingWidget = Image.network(
                item['image'],
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              );
            } else if (item['image'] != null && item['image'] is File) {
              leadingWidget = Image.file(
                item['image'],
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              );
            } else {
              leadingWidget = Container(
                width: 50.0,
                height: 50.0,
                color: Colors.grey,
              );
            }
            return ListTile(
              leading: leadingWidget,
              title: Text(item['title'] ?? ''),
              subtitle: Text('Quantity: ${item['quantity'] ?? 0}'),
              trailing: Text('Price: \$${(item['price'] ?? 0) * (item['quantity'] ?? 0)}'),
              onTap: () => removeItemFromCart(item['id']),
            );
        },
      ),
          ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Price: \$${calculateTotalPrice()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                DBHelper.checkout();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderConfirmationScreen(),
                  ),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      )
          : null,
    );
  }
}

