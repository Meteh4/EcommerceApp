import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAD3C8),
      appBar: AppBar(
        backgroundColor: const Color(0xffDAD3C8),
        title: const Text('Order Confirmation'),
      ),
      body: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/orderconfirmed.png'),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80.0,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Thank you for your order.',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}