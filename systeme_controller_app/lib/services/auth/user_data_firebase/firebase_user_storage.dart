import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data_constants.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/user_data_exception.dart';

import '../auth_services.dart';

class FirebaseUserStorage {
  final users = FirebaseFirestore.instance.collection('users');
  late List<AuthUserData> _userData;
  late final StreamController<List<AuthUserData>> _userDataStream;
  String get userCurrentId => AuthServices.firebase().currentUser!.id;

  static final _shared = FirebaseUserStorage._sharedInstance();
  FirebaseUserStorage._sharedInstance() {
    _userDataStream =
        StreamController<List<AuthUserData>>.broadcast(onListen: () {
      _userDataStream.sink.add(_userData);
    });
  }
  factory FirebaseUserStorage() => _shared;
  Stream<List<AuthUserData>> userDataStream(){
     _cacheUser();
    return _userDataStream.stream;
  }

  Future<void> _cacheUser() async {
    final userData = await getUserData(userAccountId: userCurrentId);
    _userData = userData.toList();
    _userDataStream.add(_userData);
  }

  Future<void> createUserData({
    required String userOwnId,
    required String userOwnEmail,
    required bool userHasLightsAccess,
  }) async {
    await users.add({
      userCurrentId: userOwnId,
      userEmail: userOwnEmail,
      userIsAllowedLights: userHasLightsAccess,
    });
  }

  Future<Iterable<AuthUserData>> getUserData(
      {required String userAccountId}) async {
    try {
      
      return await users.where(userId, isEqualTo: userAccountId).get().then(
          (value) => value.docs.map((doc) => AuthUserData.fromSnapshot(doc)));
        
          
    } catch (e) {
      throw CouldNotFoundUserDataException();
    }
  }

  Future<void> removeAccess({
    required String userAccountId,
    required bool userAccountAccess,
    required String fieldName,
  }) async {
    try {
      log('here : ');
      await users.doc(userAccountId).update({fieldName: userAccountAccess});
    } catch (e) {
      throw CouldNotChangeAccessException();
    }
  }
}
