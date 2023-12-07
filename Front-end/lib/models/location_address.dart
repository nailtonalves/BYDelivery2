import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationAddress {
  String endereco;
  LatLng localizacao;

  LocationAddress(this.endereco, this.localizacao);

  static LocationAddress fromJson(Map<String, dynamic> json) {
    return LocationAddress(
      json['endereco'] as String,
      LatLng(json['latitude'] as double, json['longitude'] as double),
    );
  }
}
