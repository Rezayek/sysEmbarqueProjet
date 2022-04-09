import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'lights_data_constants.dart';
import 'lights_data_model.dart';
import 'lights_exceptions.dart';


class FirebaseLightsStorage {
  final lights = FirebaseFirestore.instance.collection("lights");
  late List<LightsDataModel> _lights ;
  late final StreamController<List<LightsDataModel>> _lightsStream;
  static final _shared = FirebaseLightsStorage._sharedInstance();
  FirebaseLightsStorage._sharedInstance() {
    _lightsStream =
    StreamController<List<LightsDataModel>>.broadcast(onListen: () {
    _lightsStream.sink.add(_lights);
    });
  }
  factory FirebaseLightsStorage() => _shared;

  Stream<List<LightsDataModel>> light() {
   _cacheLight();
   return _lightsStream.stream;
  }

  Future<void> _cacheLight() async {
  final light = await getLights();
  _lights = light.toList();
  _lightsStream.add(_lights);
  }

  Future<Iterable<LightsDataModel>> getLights() async {
    try {
      final test = await lights.get().then((value) =>
          value.docs.map((doc) => LightsDataModel.fromSnapshot(doc)));
      return test;
    } catch (e) {
      throw ClouldNotFindLightsException();
    }
  }

  Future<void> updateLight(
      {required bool lightCondition, required String id}) async {
    try {
      
      await lights.doc(id).update({lightData: lightCondition});
    } catch (e) {
      throw FailedToUpdateLightException();
    }
  }
}
