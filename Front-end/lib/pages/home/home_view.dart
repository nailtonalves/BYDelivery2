import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bydelivery/components/card_delivery.dart';
import 'package:bydelivery/models/delivery.dart';
import 'package:bydelivery/models/usuario.dart';
import 'package:bydelivery/pages/feeds/feeds_view.dart';
import 'package:bydelivery/pages/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:bydelivery/pages/login/authentication.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  Usuario? user;
  HomeView({super.key, this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  // ignore: constant_identifier_names
  static const URL_HOST_API = "http://192.168.1.8:5003";
  // ignore: constant_identifier_names
  static const SERVICE_ENTREGA = "getentrega";
  static const SERVICE_TOTAL_FATURAMENTO = "gettotalfaturamento";

  int idUltimaEntrega = 0;

  Delivery? _delivery;
  bool _showCardDelivery = false;
  bool isRed = false;
  int countdown = 0;
  late Timer _timer;
  String _valorFaturado = "0,00";

  StreamSubscription? _deliverySubscription;

  @override
  void initState() {
    super.initState();
    _showAvailableDelivery();
    _totalFaturado();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        isRed = false;
        _hideAvailableDelivery();
      } else {
        countdown--;
        if (countdown == 5) {
          isRed = true;
        }
        setState(() {});
      }
    });
  }

  void _hideAvailableDelivery() {
    _timer.cancel();
    setState(() {
      _showCardDelivery = false;
    });
    _showAvailableDelivery();
  }

  Future<void> _showAvailableDelivery() async {
    await loadDeliveries();
    Future.delayed(const Duration(seconds: 5), () {
      if (_delivery != null) {
        _showCardDelivery = true;
        countdown = 16;
        _startCountdown();
      } else {
        _showAvailableDelivery();
      }
    });
  }

  @override
  void dispose() {
    _deliverySubscription?.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> loadDeliveries() async {
    dynamic resposta = await http
        .get(Uri.parse("$URL_HOST_API/$SERVICE_ENTREGA/$idUltimaEntrega"));

    final dynamic jsonData = json.decode(resposta.body);

    List<Delivery> deliveries = List.from(
      jsonData.map((delivery) => Delivery.fromJson(delivery)),
    );
    if (deliveries.isNotEmpty) {
      _delivery = deliveries.first;
      _delivery?.idMotoboy = widget.user?.id;
      idUltimaEntrega = deliveries.first.id;
    } else {
      idUltimaEntrega = 0;
      _delivery = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: const Text('Home'),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: GestureDetector(
                  onTap: () {
                    Authentication.logout();
                    // Esta função navega para a tela de login e limpa a pilha de telas
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    size: 32,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FeedsView(usuario: widget.user)),
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.comment),
                                  SizedBox(width: 8),
                                  Text("Fazer avaliação."),
                                ],
                              )),
                        )
                      ],
                    ),
                    Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Row(children: [
                            Icon(Icons.savings),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Valor faturado até o momento"),
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _totalFaturado();
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                              const Text(
                                "R\$",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                _valorFaturado,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 80),
                              ),
                            ],
                          ),
                          const Wrap(
                            children: [
                              Text(
                                "Quanto mais entregas você faz, mais seus ganho aumentam. Aqui é possível acompanhar em tempo real os valores que lucrou.",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                textScaleFactor: 0.9,
                              )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Row(children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: AnimatedCrossFade(
                          sizeCurve: Curves.easeInOutCubic,
                          firstChild: CardDelivey(
                              countdown: countdown,
                              isRed: isRed,
                              delivery: _delivery!),
                          secondChild: const SizedBox(
                            height: 50,
                            child: Text("",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber)),
                          ),
                          crossFadeState: _showCardDelivery
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 500))),
                )
              ]),
            )
          ],
        ));
  }

  Future<void> _totalFaturado() async {
    int? idUsuario = widget.user != null ? widget.user?.id : 0;
    dynamic resposta = await http
        .get(Uri.parse("$URL_HOST_API/$SERVICE_TOTAL_FATURAMENTO/$idUsuario"));

    final dynamic jsonData = json.decode(resposta.body);
    if (jsonData['total_faturamento'] == null) {
      _valorFaturado = "00,00";
    } else {
      _valorFaturado =
          jsonData['total_faturamento'].toString().replaceAll(".", ",");
    }
  }
}
