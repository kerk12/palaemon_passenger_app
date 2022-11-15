import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/config.dart';
import 'package:situm_flutter_wayfinding/situm_flutter_wayfinding.dart';

class WayfindingScreen extends StatelessWidget {
  const WayfindingScreen({Key? key}) : super(key: key);
  final Key _mapKey = const Key("situm_map");

  void _onMapLoaded(SitumFlutterWayfinding controller) {
    print("WYF> Situm Map loaded!");
    controller.onPoiSelected((poiSelectedResult) {
      print("WYF> Poi ${poiSelectedResult.poiName} selected!");
    });
    controller.onPoiDeselected((poiDeselectedResult) {
      print("WYF> Poi deselected!");
    });
    controller.onNavigationStarted((navigation) {
      print("WYF> Nav started, distance = ${navigation.route?.distance}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = context.read<Config>();
    return Scaffold(
      body: SitumMapView(
        key: _mapKey,
        situmUser: config.situmEmail,
        situmApiKey: config.situmPassword,
        buildingIdentifier: config.situmBuildingId,
        loadCallback: _onMapLoaded,
        lockCameraToBuilding: true,
        useHybridComponents: true,
        showPoiNames: true,
        hasSearchView: false,

      ),
    );
  }
}
