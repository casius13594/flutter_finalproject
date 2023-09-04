import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class Homepage extends StatefulWidget{
  const Homepage({super.key});


  @override
  State<StatefulWidget> createState()  => _HomePageState();
}

class _HomePageState extends State<Homepage>{
  late GoogleMapController mapController;
  LocationData? _currentLocation;
  Set<Marker> markers = {};

  Location location = new Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  late Stream<dynamic> query;
  late StreamSubscription subscription;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        automaticallyImplyLeading: false,
      ),
      body: _buildMap(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
    _startQuery();
  }

  void _initLocation() async {
    var locationService = Location();
    var status = await locationService.requestPermission();

    if (status == PermissionStatus.granted) {
      var location = await locationService.getLocation();
      setState(() {
        _currentLocation = location;
      });
    }
  }

  Widget _buildMap() {
    if (_currentLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            zoom: 15.0,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          markers: markers,
        ),
        Positioned(
            bottom: 150,
            right: 10,
            child:
            TextButton(
                child: Icon(Icons.pin_drop),
                onPressed: () => _startQuery()
            )
        ),
        Positioned(
            bottom: 250,
            right: 10,
            child:
            TextButton(
                child: Icon(Icons.pin_drop),
                onPressed: () => _addGeoPoint()
            )
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? userIdentifier = user.email; // Use email if available, otherwise use UID

      await firestore.collection('locations').doc(userIdentifier).set({
        'email': user.email,
        'position': point.data,
        'name': 'Yay I can be queried!'
      });
    }

  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    setState(() {
      markers.clear();
    });
    documentList.forEach((DocumentSnapshot document) {
      final data = document.data() as Map<String, dynamic>?;

      if (data != null) {
        final geopoint = data['position']['geopoint'] as GeoPoint?;
        final markerTitle = data['email'] as String?;
        if (geopoint != null) {
          var markerIdVal = UniqueKey().toString(); // Generate a unique markerId
          var marker = Marker(
            markerId: MarkerId(markerIdVal),
            position: LatLng(geopoint.latitude, geopoint.longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: markerTitle
            ),
          );

          setState(() {
            markers.add(marker); // Add the marker to the set
          });
        }
      }
    });
  }

  _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos.latitude!;
    double lng = pos.longitude!;
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // Set a radius for query (in kilometers)
    double radius = 5;

    var collectionReference = firestore.collection('locations');
    var stream = geo.collection(collectionRef: collectionReference).within(
      center: center,
      radius: radius,
      field: 'position',
    );

    subscription = stream.listen(_updateMarkers);
  }

}