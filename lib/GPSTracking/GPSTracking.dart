import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/menu.dart';

class GPSTracking extends StatefulWidget {
  @override
  _GPSTrackingState createState() => _GPSTrackingState();
}

class _GPSTrackingState extends State<GPSTracking> {
  GoogleMapController? mapController;

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8081/mn_641463021/GPS/gps.php'));

      if (response.statusCode == 200) {
        List<dynamic> locations = json.decode(response.body);
        _updateMarkers(locations);
      } else {
        throw Exception('การโหลดตำแหน่งผิดพลาด');
      }
    } catch (e) {
      // Handle errors more gracefully
      print('Error fetching locations: $e');
    }
  }

  void _updateMarkers(List<dynamic> locations) {
    setState(() {
      markers = locations.map((location) {
        return Marker(
          markerId: MarkerId(location['AttractionID'].toString()),
          position: LatLng(double.parse(location['Latitude']),
              double.parse(location['Longitude'])),
          infoWindow: InfoWindow(
            title: location['AttractionName'],
          ),
          // You can customize the marker icon here if needed
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'GPS',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(13.7563, 100.5018),
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
        },
        markers: Set<Marker>.of(markers),
        // Additional GoogleMap configuration...
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