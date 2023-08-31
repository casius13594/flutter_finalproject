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
  late GoogleMapController _mapController;
  LocationData? _currentLocation;

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

  Widget _buildMap() {
    if (_currentLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 15.0,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
    );
  }
}