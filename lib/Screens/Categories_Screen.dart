import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shoptral1/Screens/Products_Page.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      var response = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories = List<String>.from(jsonDecode(response.body));
        });
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String getImageUrlByCategory(String category) {
    switch (category) {
      case 'electronics':
        return 'assets/images/electronics.png';
      case 'jewelery':
        return 'assets/images/jewelery.png';
      case 'men\'s clothing':
        return 'assets/images/mensch.png';
      case 'women\'s clothing':
        return 'assets/images/womensch.png';

      default:
        return 'assets/images/placeholder.png';
    }
  }

  Route _createRoute(String category) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProductsPage(category: category),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        String category = categories[index];
        String imageUrl = getImageUrlByCategory(category);

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(_createRoute(category));
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
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
                Image.asset(
                  imageUrl,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8.0),
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}