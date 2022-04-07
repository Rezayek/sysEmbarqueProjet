import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systeme_controller_app/services/data_contollers/lights_data_constants.dart';

class LighrsDataModel {
  final String docId;
  final bool light_1;
  final bool light_2;

  LighrsDataModel({required this.docId, required this.light_1, required this.light_2});

  LighrsDataModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docId = snapshot.id,
        light_1 = snapshot.data()[light1Data],
        light_2 = snapshot.data()[light2Data];
}
