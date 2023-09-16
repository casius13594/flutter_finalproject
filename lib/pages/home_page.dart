import 'dart:async';
import 'dart:math';

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
  LocationData? _currentLocation, _previousLocation;
  Set<Marker> markers = {};
  Timer? updateTimer;

  Location location = new Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  late Stream<dynamic> query;
  late StreamSubscription subscription;
  StreamSubscription<LocationData>? locationSubscription;


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
    _startPeriodicUpdates();
  }

  @override
  void dispose() {
    mapController.dispose();
    locationSubscription?.cancel();
    subscription.cancel();
    updateTimer?.cancel();
    super.dispose();
  }

  void _initLocation() async {
    var locationService = Location();
    var status = await locationService.requestPermission();

    if (status == PermissionStatus.granted) {
      var location = await locationService.getLocation();
      setState(() {
        _currentLocation = location;
        _updateGeoPoint();
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
          myLocationEnabled: false,
          mapType: MapType.hybrid,
          markers: markers,
        ),
        Positioned(
            bottom: 150,
            right: 10,
            child:
            TextButton(
                child: Icon(Icons.refresh),
                onPressed: () => _updateGeoPoint()
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

  void _startPeriodicUpdates() {
    updateTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      try {
        var newLocation = await location.getLocation();
        if (_previousLocation != null) {
          double distance = distanceBetween(
            _previousLocation!.latitude!,
            _previousLocation!.longitude!,
            newLocation.latitude!,
            newLocation.longitude!,
          );

        if (distance >= 0.05) {
          // If distance >= 50m, update data and markers
          _updateGeoPoint();
        }
        }

        setState(() {
          _currentLocation = newLocation;
          _previousLocation = newLocation;
        });
      } catch (e) {
        print("Error getting location: $e");
      }
    });
  }

  Future<void> _updateGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? userIdentifier = user.email;

      DocumentReference userDocRef = firestore.collection('locations').doc(userIdentifier);

      // Check if the document exists
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Update the existing document's "position" field
        await userDocRef.update({
          'position': point.data,
        });
      } else {
        // Create a new document with the user's email as the document ID
        await userDocRef.set({
          'email': user.email, // Store the user's email
          'position': point.data,
        });
      }
    }
    _startQuery();
  }

  _startQuery() async {
    // Get the current user
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? userIdentifier = user.email;

      // Query the "friend" collection for documents where "state" is 2 and the current user's email is either in "friend 1"
      var friendQuery = firestore.collection('friend')
          .where('state', isEqualTo: 2)
          .where('friend1', isEqualTo: userIdentifier)
          .get();

      // Retrieve the "friend 2" emails from the query results
      var friendEmails = (await friendQuery).docs.map((doc) => doc['friend2']).toList();

      // Query the "friend" collection again for documents where "state" is 2 and the current user's email is in "friend 2"
      var friendQuery2 = firestore.collection('friend')
          .where('state', isEqualTo: 2)
          .where('friend2', isEqualTo: userIdentifier)
          .get();

      // Retrieve the "friend 1" emails from the second query results
      var friendEmails2 = (await friendQuery2).docs.map((doc) => doc['friend1']).toList();

      // Combine both lists of friend emails
      var emailsMarker = [...friendEmails, ...friendEmails2, userIdentifier];

      // Get users location
      var pos = await location.getLocation();
      double lat = pos.latitude!;
      double lng = pos.longitude!;
      GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

      // Set a radius for the query (in kilometers)
      double radius = 5;

      // Query the "locations" collection for documents where the email is in the emailsMarker list
      var firestoreQuery = firestore.collection('locations').where('email', whereIn: emailsMarker);

      var stream = geo.collection(collectionRef: firestoreQuery).within(
        center: center,
        radius: radius,
        field: 'position',
      );

      // Listen to the locationQuery stream and update the markers
      subscription = stream.listen(_updateMarkers);
    }
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    var user = FirebaseAuth.instance.currentUser;
    String? currentUserEmail = user?.email;

    setState(() {
      markers.clear();
    });

    documentList.forEach((DocumentSnapshot document) {
      final data = document.data() as Map<String, dynamic>?;

      if (data != null) {
        final geopoint = data['position']['geopoint'] as GeoPoint?;
        final markerTitle = data['email'] as String?;
        if (geopoint != null) {
          double distanceFriend = distanceBetween(_currentLocation!.latitude!,
              _currentLocation!.longitude!, geopoint.latitude, geopoint.longitude);

          var markerIdVal = UniqueKey().toString(); // Generate a unique markerId
          var marker = Marker(
            markerId: MarkerId(markerIdVal),
            position: LatLng(geopoint.latitude, geopoint.longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: markerTitle,
              snippet: 'Distance: ${distanceFriend.toStringAsFixed(2)} km',
            ),
          );


          if (currentUserEmail != null && markerTitle == currentUserEmail) {
            // Customize the marker for the current user
            marker = marker.copyWith(
              iconParam: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            );
          }

          setState(() {
            markers.add(marker); // Add the marker to the set
          });
        }
      }
    });
  }

  double deg2rad(double deg) {
    return deg * (pi / 180);
  }

  double rad2deg(double rad) {
    return rad * (180 / pi);
  }

  double distanceBetween(double lat1, double lng1, double lat2, double lng2) {
    double theta = lng1 - lng2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.60934; // Distance in kilometers
    return dist;
  }

}