import 'package:bydelivery/models/location_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Delivery {
  int id;
  int idEstabelecimento;
  String nomeCliente;
  LocationAddress localRetiradaEncomenda;
  LocationAddress localEntregaEncomenda;
  String dataCriacao;
  String? dataEntrega;
  int? idMotoboy;
  String status;
  String valor;

  Delivery(
    this.id,
    this.idEstabelecimento,
    this.nomeCliente,
    this.localRetiradaEncomenda,
    this.localEntregaEncomenda,
    this.dataCriacao,
    this.dataEntrega,
    this.idMotoboy,
    this.status,
    this.valor,
  );

  static fromJson(Map<String, dynamic> json) {
    return Delivery(
        json['id'] as int,
        json['id_estabelecimento'] as int,
        json['nome_cliente'] as String,
        LocationAddress(
          json['estabelecimento_endereco'] as String,
          LatLng(json['estabelecimento_latitude'] as double,
              json['estabelecimento_longitude'] as double),
        ),
        LocationAddress(
          json['cliente_endereco'] as String,
          LatLng(json['cliente_latitude'] as double,
              json['cliente_longitude'] as double),
        ),
        json['data_criacao'] as String,
        json['data_entrega'],
        json['id_usuario'],
        json['status'] as String,
        json['valor'] as String);
  }
}
