import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:systeme_controller_app/services/data_contollers/lights_data_model.dart';
import 'package:systeme_controller_app/services/data_contollers/lights_exceptions.dart';

class FirebaseLightsStorage {
  final lights = FirebaseFirestore.instance.collection("lights");
  late List<LighrsDataModel> _lights = [] ;
  late final StreamController<List<LighrsDataModel>> _lightsStream;
  static final _shared = FirebaseLightsStorage._sharedInstance();
  FirebaseLightsStorage._sharedInstance() {
    _lightsStream =
    StreamController<List<LighrsDataModel>>.broadcast(onListen: () {
    _lightsStream.sink.add(_lights);
    });
  }
  factory FirebaseLightsStorage() => _shared;

  Stream<List<LighrsDataModel>> light() {
   _cacheLight();
   return _lightsStream.stream;
  }

  Future<void> _cacheLight() async {
  final light = await getLights();
  _lights = light.toList();
  _lightsStream.add(_lights);
  }

  Future<Iterable<LighrsDataModel>> getLights() async {
    try {
      log('read');
      log(lights.toString());
      log(lights.doc().toString());
      final test = await lights.get().then((value) =>
          value.docs.map((doc) => LighrsDataModel.fromSnapshot(doc)));
      log(test.toList().toString());
      log('read');
      return test;
    } catch (e) {
      throw ClouldNotFindLightsException();
    }
  }

  Future<void> updateLight(
      {required String light, required bool lightCondition, required String id}) async {
    try {
      
      await lights.doc(id).update({light: lightCondition});
    } catch (e) {
      throw FailedToUpdateLightException();
    }
  }
}
