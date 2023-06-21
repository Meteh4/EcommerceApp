import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart.db');
    return openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart_items (
            id INTEGER PRIMARY KEY,
            title TEXT,
            category TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
    );
  }

  static Future<int> getCartItemQuantity(int productId) async {
    final Database database = await _openDatabase();
    final List<Map<String, dynamic>> cartItems = await database.query(
      'cart_items',
      where: 'id = ?',
      whereArgs: [productId],
    );

    await database.close();

    if (cartItems.isNotEmpty) {
      return cartItems[0]['quantity'];
    }

    return 0;
  }

  static Future<void> addToCart(dynamic product, int quantity) async {
    final cartItem = {
      'id': product['id'],
      'title': product['title'],
      'category': product['category'],
      'price': product['price'],
      'quantity': quantity,
    };

    final Database database = await _openDatabase();
    await database.insert(
      'cart_items',
      cartItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await database.close();
  }

  static Future<void> removeFromCart(dynamic product) async {
    final Database database = await _openDatabase();
    await database.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [product['id']],
    );

    await database.close();
  }


  static Future<void> checkout() async {
    final Database cartDatabase = await _openDatabase();
    final List<Map<String, dynamic>> cartItems = await cartDatabase.query('cart_items');

    if (cartItems.isEmpty) {
      print('Cart is empty. No items to checkout.');
      await cartDatabase.close();
      return;
    }

    final Database ordersDatabase = await _openOrdersDatabase();
    await ordersDatabase.transaction((txn) async {
      for (final cartItem in cartItems) {
        await txn.insert(
          'siparisler',
          {
            'id': cartItem['id'],
            'title': cartItem['title'],
            'category': cartItem['category'],
            'price': cartItem['price'],
            'quantity': cartItem['quantity'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });

    await cartDatabase.delete('cart_items');
    await cartDatabase.close();
    await ordersDatabase.close();

    print('Checkout successful. Items are transferred to the "siparisler" table.');
  }

  static Future<Database> _openOrdersDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');
    return openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE siparisler (
            id INTEGER PRIMARY KEY,
            title TEXT,
            category TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
    );
  }
}



