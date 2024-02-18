import 'package:flutter/material.dart';
import 'package:mn_641463021/GPSTracking/GPSTracking.dart';
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Products/Products.dart';
import 'package:mn_641463021/Shops/Shops.dart';
import 'package:mn_641463021/Tour/Tour.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digital Twin',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ResponsiveMenuGrid(),
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

class ResponsiveMenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Use a smaller grid for narrower screens
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            MenuItem(
              title: 'login',
              icon: Icons.login,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            MenuItem(
              title: 'ร้านค้า',
              icon: Icons.store,
              onTap: () {
                // Add action to navigate to store page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Shops(),
                  ),
                );
              },
            ),
            MenuItem(
              title: 'สินค้า',
              icon: Icons.shopping_cart,
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Products()),
                  );
              },
            ),
            MenuItem(
              title: 'ตารางการเดินรถ',
              icon: Icons.directions_bus,
              onTap: () {
                // Add action to navigate to bus schedule page
              },
            ),
            MenuItem(
              title: 'GPs',
              icon: Icons.location_on,
              onTap: () {
                // Add action to navigate to GPS tracking page
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => GPSTracking()),
                  );
              },
            ),
            MenuItem(
              title: 'สถานที่ท่องเที่ยว',
              icon: Icons.tour_sharp,
              onTap: () {
                // Add action to navigate to health temperature page
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Touristattractions()),
                  );
              },
            ),
          ],
        );
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50.0, color: Colors.blue),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(fontSize: 16.0, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
