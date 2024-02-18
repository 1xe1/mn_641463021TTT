import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'dart:convert';

import 'package:mn_641463021/menu.dart';

class UpdateShop extends StatefulWidget {
  final Map<String, dynamic> shop;

  UpdateShop({required this.shop});

  @override
  _UpdateShopState createState() => _UpdateShopState();
}

class _UpdateShopState extends State<UpdateShop> {
  final TextEditingController _shopNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _shopNameController.text = widget.shop['ShopName'];
  }

  Future<void> submitForm(BuildContext context) async {
    final String shopName = _shopNameController.text;

    try {
      final String apiUrl = "http://localhost:8081/mn_641463021/Shop/";
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'ShopID': widget.shop['ShopID'],
          'ShopName': shopName,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to update shop. Error ${response.statusCode}"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Error submitting form: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Shop',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  submitForm(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu_rounded),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Menu()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              color: Colors.white,
              onPressed: () {
                // Add action to manage user info
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
