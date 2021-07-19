import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';

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
    print('_generateRandomLocation $origin');
    print('randomLat $randomLat');
    print('randomLng $randomLng');
    return LatLng(origin.latitude + randomLat, origin.longitude + randomLng);
  }
}

class MapState {
  final LatLng location;
  MapState({this.location});
}