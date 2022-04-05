import 'package:flutter/material.dart';

import 'package:systeme_controller_app/services/auth/auth_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:systeme_controller_app/views/main_views/main_view.dart';

// ignore: must_be_immutable
class QrView extends StatefulWidget {
  String specificSystem;
  QrView({Key? key, required this.specificSystem})
      : super(
          key: key,
        );
  @override
  // ignore: no_logic_in_create_state
  State<QrView> createState() => _QrViewState(specificSystem: specificSystem);
}

class _QrViewState extends State<QrView> {
  String specificSystem;
  String get userId => AuthServices.firebase().currentUser!.id;
  _QrViewState({required this.specificSystem});
  @override
  Widget build(BuildContext context) {
    String qrCode = userId + '_' + specificSystem;
    GlobalKey globalKey = new GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text('QR code', style: TextStyle(fontSize: 20),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                const Text('Hold your phone screen in the front of th camera', style: TextStyle(fontSize: 26),),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Center(
                        child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: qrCode,
                    size: 240,
                  ),
                )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
