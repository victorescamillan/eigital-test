import 'dart:async';
import 'dart:math';
import 'package:eigital_test/blocs/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}


class _MapPageState extends State<MapPage> {
  Position _currentLocation;

  Completer<GoogleMapController> _controller = Completer();

  static final LatLng center = const LatLng(-33.86711, 151.1947171);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
  );

  CameraPosition _randomPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MapBloc>(context, listen: true);
    if(_currentLocation == null){
      return Center(child: CircularProgressIndicator(strokeWidth: 2,),);
    }

    return _displayGoogleMap(bloc);
  }

  void _addMarker() {
    final MarkerId markerId = MarkerId('marker_id_1');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        _currentLocation.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        _currentLocation.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: 'markerIdVal', snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    print('markerId $markerId');
    // final Marker tappedMarker = markers[markerId];
    // if (tappedMarker != null) {
    //   setState(() {
    //     final MarkerId previousMarkerId = selectedMarker;
    //     if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
    //       final Marker resetOld = markers[previousMarkerId]
    //           .copyWith(iconParam: BitmapDescriptor.defaultMarker);
    //       markers[previousMarkerId] = resetOld;
    //     }
    //     selectedMarker = markerId;
    //     final Marker newMarker = tappedMarker.copyWith(
    //       iconParam: BitmapDescriptor.defaultMarkerWithHue(
    //         BitmapDescriptor.hueGreen,
    //       ),
    //     );
    //     markers[markerId] = newMarker;
    //   });
    // }
  }


  Future<void> _goToRandomPosition(LatLng latLng) async {
    CameraPosition randomPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: latLng,
      zoom: 8.0,
      tilt: 59.440717697143555,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(randomPosition));
  }

  Widget _displayGoogleMap(MapBloc bloc){
    bloc.state == null ? _addMarker() : _goToRandomPosition(bloc.state);
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
        CameraPosition(
          target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
          zoom: 12.0,
        ),
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          bloc.add(MapState(location: LatLng(_currentLocation.latitude, _currentLocation.longitude)));
        },
        label: Text('Random Location'),
        icon: Icon(Icons.directions),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = position;
    });
  }
}
