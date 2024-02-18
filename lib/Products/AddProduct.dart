import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'dart:convert';

import 'package:mn_641463021/menu.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController _productNameController = TextEditingController();
  String _selectedShopID = ''; // Variable to store the selected ShopID
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _shops = []; // List to store shops

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    try {
      final response = await http.get(Uri.parse(
          "http://localhost:8081/mn_641463021/Products/Products.php"));

      if (response.statusCode == 200) {
        setState(() {
          _shops = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        // Show an error message if failed to load shops
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content:
                  Text("Failed to load shops. Error ${response.statusCode}"),
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
      // Show an error message if an exception occurred
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Error fetching shops: $e"),
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

  Future<void> submitForm(BuildContext context) async {
    // Validate input fields
    if (_productNameController.text.isEmpty ||
        _selectedShopID.isEmpty ||
        _unitController.text.isEmpty ||
        _priceController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all fields."),
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
      return;
    }

    final String productName = _productNameController.text;
    final String unit = _unitController.text;
    final double price = double.tryParse(_priceController.text) ?? 0.0;

    try {
      final String apiUrl =
          "http://localhost:8081/mn_641463021/Products/Products.php";
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'ProductName': productName,
          'ShopID': _selectedShopID, // Use the selected ShopID
          'Unit': unit,
          'Price': price,
        }),
      );
      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message or navigate back
        fetchShops();
        Navigator.pop(context);
      } else {
        // Handle error, e.g., show an error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content:
                  Text("Failed to add product. Error ${response.statusCode}"),
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
      // Handle other exceptions
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
          'Add Product',
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
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedShopID.isNotEmpty ? _selectedShopID : null,
                items: _buildDropdownItems(),
                onChanged: (value) {
                  setState(() {
                    _selectedShopID = value ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Shop'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _unitController,
                decoration: InputDecoration(labelText: 'Unit'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _priceController,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Price'),
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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    List<String> shopIDs = [];
    List<DropdownMenuItem<String>> items = [];

    for (var shop in _shops) {
      final String shopID = shop['ShopID'].toString();
      if (!shopIDs.contains(shopID)) {
        shopIDs.add(shopID);
        items.add(
          DropdownMenuItem<String>(
            value: shopID,
            child: Text(shop['ShopName']),
          ),
        );
      }
    }

    return items;
  }
}
