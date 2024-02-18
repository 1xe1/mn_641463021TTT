import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Products/AddProduct.dart';
import 'package:mn_641463021/Products/UpdateProduct.dart';
import 'package:mn_641463021/menu.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Map<String, dynamic>> products = [];
  int _currentSortColumnIndex = 0;
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
        Uri.parse("http://localhost:8081/mn_641463021/Products/Products.php"));

    if (response.statusCode == 200) {
      setState(() {
        products = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load products. Error ${response.statusCode}');
    }
  }

  void navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProducts(),
      ),
    ).then((_) {
      fetchProducts();
    });
  }

  void _navigateToEditProduct(Map<String, dynamic> product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateProduct(product: product),
    ),
  ).then((_) {
    fetchProducts(); // เรียก fetchProducts() เมื่อการอัพเดทสินค้าเสร็จสมบูรณ์
  });
}

  Future<void> _deleteProduct(int productID) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8081/mn_641463021/Products/Products.php'),
        body: json.encode({'ProductID': productID}),
      );

      if (response.statusCode == 200) {
        // Product deleted successfully, update UI or show a message
        fetchProducts(); // Refresh products list after deletion
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
                "ลบสินค้าเสร็จสมบูรณ์",
                style: TextStyle(
                  fontSize: 18.0, // Increase font size for better readability
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors
                          .green, // Match text color with title for consistency
                      fontSize:
                          16.0, // Match font size with content for consistency
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
        // Failed to delete product, handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to delete product. Error ${response.statusCode}"),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายการสินค้า',
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
        body: products.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortColumnIndex: _currentSortColumnIndex,
                  sortAscending: _isSortAscending,
                  columns: [
                    DataColumn(
                      label: Text('ชื่อสินค้า'),
                      onSort: (columnIndex, _) {
                        _sort(columnIndex);
                      },
                    ),
                    DataColumn(label: Text('ชื่อร้านค้า')),
                    DataColumn(label: Text('หน่วย')),
                    DataColumn(label: Text('ราคา')),
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
          onPressed: navigateToAddProduct,
          tooltip: 'เพิ่มสินค้า',
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
    return products.map((product) {
      return DataRow(cells: [
        DataCell(
          Text(
            product['ProductName'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(product['ShopName'])),
        DataCell(Text(product['Unit'].toString())),
        DataCell(Text(product['Price'].toString())),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit page and pass product data
              _navigateToEditProduct(product);
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Call delete function here
              _deleteProduct(int.parse(product['ProductID'].toString()));
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

    products.sort((a, b) {
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
}
