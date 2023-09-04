import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Homepage extends StatefulWidget{
  const Homepage({super.key});


  @override
  State<StatefulWidget> createState()  => _HomePageState();
}

class _HomePageState extends State<Homepage>{
  late GoogleMapController mapController;
  LocationData? _currentLocation;
  Set<Marker> markers = {};

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
            bottom: 50,
            right: 10,
            child:
            TextButton(
                child: Icon(Icons.pin_drop, color: Color.fromRGBO(255,255,255, 0.9)),
                onPressed: () => _addMarker(),
            )
        )
      ]
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _addMarker() {
    var markerIdVal = UniqueKey().toString(); // Generate a unique markerId
    var marker = Marker(
      markerId: MarkerId(markerIdVal), // Use the generated markerId
      position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Magic Marker',
        snippet: '🍄🍄🍄',
      ),
    );

    setState(() {
      markers.add(marker); // Add the new marker to the set
    });
  }
}