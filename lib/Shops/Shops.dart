import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Shops/AddShop.dart';
import 'package:mn_641463021/Shops/UpdateShop.dart';
import 'package:mn_641463021/menu.dart';

class Shops extends StatefulWidget {
  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  List<Map<String, dynamic>> shops = [];
  int _currentSortColumnIndex = 0;
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    final response = await http.get(
      Uri.parse("http://localhost:8081/mn_641463021/Shop/"),
    );

    if (response.statusCode == 200) {
      setState(() {
        shops = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load shops. Error ${response.statusCode}');
    }
  }
  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddShop(),
      ),
    ).then((_) {
      fetchShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายการร้านค้า',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Menu(),
                ),
              );
            },
          ),
        ),
        body: shops.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortColumnIndex: _currentSortColumnIndex,
                  sortAscending: _isSortAscending,
                  columns: [
                    DataColumn(
                      label: Text('ชื่อร้านค้า'),
                      onSort: (columnIndex, _) {
                        _sort(columnIndex);
                      },
                    ),
                    DataColumn(label: Text('แก้ไข')),
                    DataColumn(label: Text('ลบ')),
                  ],
                  rows: _createRows(),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: navigateToAdd,
          tooltip: 'เพิ่มร้านค้า',
          child: Icon(Icons.add),
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
      ),
    );
  }

  List<DataRow> _createRows() {
    return shops.map((shop) {
      return DataRow(cells: [
        DataCell(
          Text(
            shop['ShopName'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit page and pass shop data
              _navigateToEdit(shop);
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Call delete function here
              _deleteShop(int.parse(shop['ShopID'].toString()));
              
            },
          ),
        ),
      ]);
    }).toList();
  }

  void _sort(int columnIndex) {
    if (columnIndex == _currentSortColumnIndex) {
      setState(() {
        _isSortAscending = !_isSortAscending;
      });
    } else {
      setState(() {
        _currentSortColumnIndex = columnIndex;
        _isSortAscending = true;
      });
    }

    shops.sort((a, b) {
      if (_isSortAscending) {
        return a.values
            .elementAt(columnIndex)
            .compareTo(b.values.elementAt(columnIndex));
      } else {
        return b.values
            .elementAt(columnIndex)
            .compareTo(a.values.elementAt(columnIndex));
      }
    });
  }
  Future<void> _deleteShop(int shopID) async {
  try {
    final response = await http.delete(
      Uri.parse('http://localhost:8081/mn_641463021/Shop/'),
      body: json.encode({'ShopID': shopID}),
    );

    if (response.statusCode == 200) {
      // Shop deleted successfully, update UI or show a message
      fetchShops(); // Refresh shops list after deletion
      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Success",
              style: TextStyle(
                color: Colors.green, // Set text color to green for success
              ),
            ),
            content: Text(
              "ลบร้านเรียบร้อย",
              style: TextStyle(
                fontSize: 18.0, // Increase font size for better readability
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.green, // Match text color with title for consistency
                    fontSize: 16.0, // Match font size with content for consistency
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Failed to delete shop, handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
              "Failed to delete shop. Error ${response.statusCode}",
            ),
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
    // Handle any exceptions
    print('Error: $e');
  }
}
void _navigateToEdit(Map<String, dynamic> shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateShop(shop: shop),
      ),
    ).then((_) {
      fetchShops(); // Call fetchAttractions() when updating is completed
    });
  }

}

