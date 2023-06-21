import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shoptral1/Screens/Product_Detail_Screen.dart';

class ProductsPage extends StatefulWidget {
  final String category;

  const ProductsPage({Key? key, required this.category}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/${widget.category}'));
      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void navigateToProductDetail(dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDAD3C8),
      appBar: AppBar(
        backgroundColor: Color(0xffDAD3C8),
        title: Text(widget.category.toUpperCase()),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];

          return Container(
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
            child: ListTile(
              leading: Image.network(
                product['image'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              title: Text(product['title']),
              subtitle: Text('\$${product['price']}'),
              onTap: () {
                navigateToProductDetail(product);
              },
            ),
          );
        },
      ),
    );
  }
  }