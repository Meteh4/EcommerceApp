import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../db/Database Helper.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isExpanded = false;
  int quantity = 0;
  List<dynamic> comments = [];
  bool showComments = false;

  final DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    getCartItemQuantity();
    fetchComments();
  }

  Future<void> getCartItemQuantity() async {
    final int cartQuantity = await DBHelper.getCartItemQuantity(widget.product['id']);
    setState(() {
      quantity = cartQuantity;
    });
  }

  Future<void> addToCart() async {
    setState(() {
      quantity++;
    });

    await DBHelper.addToCart(widget.product, quantity);
  }

  Future<void> removeFromCart() async {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });

      await DBHelper.removeFromCart(widget.product);
    }
  }

  Future<void> fetchComments() async {
    try {
      var response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/comments'));
      if (response.statusCode == 200) {
        setState(() {
          comments = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch comments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAD3C8),
      appBar: AppBar(
        backgroundColor: const Color(0xffDAD3C8),
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
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
                child: Image.network(
                  widget.product['image'],
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
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
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      widget.product['title'],
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Category: ${widget.product['category']}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Price: \$${widget.product['price']}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
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
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating: widget.product['rating']['rate'],
                      itemBuilder: (context, index) =>
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '(${widget.product['rating']['count']} Reviews)',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
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
                child: Column(
                  children: [
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.product['description'],
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
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
                child: Row(
                  children: [
                    if (quantity > 0) ...[
                      IconButton(
                        onPressed: removeFromCart,
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        splashRadius: 20.0,
                        iconSize: 20.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'On Cart: $quantity',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                    if (quantity == 0) ...[
                      TextButton(
                        onPressed: addToCart,
                        child: const Row(
                          children: [
                            Icon(Icons.shopping_cart),
                            SizedBox(width: 5.0),
                            Text('Sepete Ekle'),
                          ],
                        ),
                      )
                    ],
                    if (quantity > 0) ...[
                      IconButton(
                        onPressed: addToCart,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        splashRadius: 20.0,
                        iconSize: 20.0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartScreen()),
                          );
                        },
                        child: const Text('Go to Cart'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments (${widget.product['rating']['count']})',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.product['rating']['count'] <= 0
                        ? 0
                        : widget.product['rating']['count'],
                    itemBuilder: (context, index) {
                      var comment = comments[index];
                      return ListTile(
                        title: Text(
                          comment['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['email']),
                            const SizedBox(height: 4.0),
                            Text(comment['body']),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

