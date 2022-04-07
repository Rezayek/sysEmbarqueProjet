import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data_constants.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/user_data_exception.dart';

class FirebaseUserStorage {
  final users = FirebaseFirestore.instance.collection('users');

  static final _shared = FirebaseUserStorage._sharedInstance();
  FirebaseUserStorage._sharedInstance();
  factory FirebaseUserStorage() => _shared;

  Future<void> createUserData({
    required String userOwnId,
    required String userOwnEmail,
    required bool userHasLightsAccess,
  }) async {
     await users.add({
      userId: userOwnId,
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
  }) async {
    try {
      await users.doc(userAccountId).update({userIsAllowedLights: userAccountAccess});
    } catch (e) {
      throw CouldNotChangeAccessException();
    }
  }
}
