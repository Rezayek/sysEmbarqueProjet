import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systeme_controller_app/services/data_contollers/fans_controller/fans_data_constants.dart';

class FansDataModel {
  final String fanId;
  final bool isSpinnig;
  final bool mode1;
  final bool mode2;

  FansDataModel(
      {required this.fanId,
      required this.isSpinnig,
      required this.mode1,
      required this.mode2});

  FansDataModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : fanId = snapshot.id,
        isSpinnig = snapshot.data()[fanSpinning],
        mode1 = snapshot.data()[fanSpeedMode1],
        mode2 = snapshot.data()[fanSpeedMode2];
}
