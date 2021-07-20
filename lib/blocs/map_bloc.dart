import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBloc extends Bloc<MapState, LatLng>{
  MapBloc(LatLng initialState) : super(initialState);

  @override
  Stream<LatLng> mapEventToState(MapState state) async* {
    // TODO: implement mapEventToState
    yield _generateRandomLocation(state.location);
  }

  LatLng _generateRandomLocation(LatLng origin){
    Random random = new Random();
    double randomLat = random.nextDouble();
    double randomLng = random.nextDouble();
    return LatLng(origin.latitude + randomLat, origin.longitude + randomLng);
  }
}

class MapState {
  final LatLng location;
  MapState({this.location});
}