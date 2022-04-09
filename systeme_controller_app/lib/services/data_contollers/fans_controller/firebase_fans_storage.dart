import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'fans_data_exceptions.dart';
import 'fans_data_model.dart';

class FirebaseFansStorage {
  final fans = FirebaseFirestore.instance.collection("fans");
  late List<FansDataModel> _fans;
  late final StreamController<List<FansDataModel>> _fansStream;
  static final _shared = FirebaseFansStorage._sharedInstance();
  FirebaseFansStorage._sharedInstance() {
    _fansStream = StreamController<List<FansDataModel>>.broadcast(onListen: () {
      _fansStream.sink.add(_fans);
    });
  }
  factory FirebaseFansStorage() => _shared;

  Stream<List<FansDataModel>> fan() {
    _cacheFan();
    return _fansStream.stream;
  }

  Future<void> _cacheFan() async {
    final fans = await getFans();
    _fans = fans.toList();
    _fansStream.add(_fans);
  }

  Future<Iterable<FansDataModel>> getFans() async {
    try {
      final test = await fans.get().then(
          (value) => value.docs.map((doc) => FansDataModel.fromSnapshot(doc)));

      log(test.elementAt(0).isSpinnig.toString());
      return test;
    } catch (e) {
      throw ClouldNotFindFansException();
    }
  }

  Future<void> updateFan(
      {required bool condition, required String id, required fieldName}) async {
    try {
      await fans.doc(id).update({fieldName: condition});
    } catch (e) {
      throw FailedToUpdateLightException();
    }
  }
}
