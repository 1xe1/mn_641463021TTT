import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'dart:convert';

import 'package:mn_641463021/menu.dart';

class AddTouristattractions extends StatefulWidget {
  @override
  _AddTouristattractionsState createState() => _AddTouristattractionsState();
}

class _AddTouristattractionsState extends State<AddTouristattractions> {
  final TextEditingController _attractionNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Attraction',
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
                controller: _attractionNameController,
                decoration: InputDecoration(labelText: 'Attraction Name'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _latitudeController,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Latitude'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _longitudeController,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Longitude'),
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

  Future<void> submitForm(BuildContext context) async {
    if (_attractionNameController.text.isEmpty ||
        _latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty) {
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

    final String attractionName = _attractionNameController.text;
    final double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    final double longitude = double.tryParse(_longitudeController.text) ?? 0.0;

    try {
      final String apiUrl =
          "http://localhost:8081/mn_641463021/Touristattractions/";
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'AttractionName': attractionName,
          'Latitude': latitude,
          'Longitude': longitude,
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
              content:
                  Text("Failed to add attraction. Error ${response.statusCode}"),
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
}
