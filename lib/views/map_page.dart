import 'package:eigital_test/blocs/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}


class _MapPageState extends State<MapPage> {
  Position _currentLocation;
  Position _tempLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MapBloc>(context);
    if(_currentLocation == null){
      return Center(child: CircularProgressIndicator(strokeWidth: 2,),);
    }
    return FlutterMap(
      options: MapOptions(
        center: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(_currentLocation.latitude, _currentLocation.longitude),
              builder: (ctx) =>
                  InkWell(
                    onTap: () => bloc.add(MapState(location: LatLng(_currentLocation.latitude, _currentLocation.longitude))),
                    child: Container(
                      child: Icon(Icons.location_on, color: Colors.redAccent, size: 50,),
                    ),
                  )
            ),
          ],
        ),
      ],
    );
  }

  _generateRandomLocation() {
    var res = Geolocator.distanceBetween(_currentLocation.latitude, _currentLocation.longitude, _currentLocation.latitude, _currentLocation.longitude);    print('_generateRandomLocation $res');

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
      _tempLocation = position;
    });
  }
}
