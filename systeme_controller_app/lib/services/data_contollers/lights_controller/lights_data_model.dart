import 'package:cloud_firestore/cloud_firestore.dart';

import 'lights_data_constants.dart';


class LightsDataModel {
  final String docId;
  final bool light;

  LightsDataModel({required this.docId, required this.light});

  LightsDataModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docId = snapshot.id,
        light = snapshot.data()[lightData];
}
