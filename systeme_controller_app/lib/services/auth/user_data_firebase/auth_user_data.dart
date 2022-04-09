import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data_constants.dart';

class AuthUserData {
  final String userDataId;
  final String userDataEmail;
  final bool userAccessLights;
  final bool userAccessFans;

  AuthUserData(
      {required this.userDataId,
      required this.userDataEmail,
      required this.userAccessLights,
      required this.userAccessFans});

  AuthUserData.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userDataId = snapshot.id,
        userDataEmail = snapshot.data()[userEmail],
        userAccessLights = snapshot.data()[userIsAllowedLights],
        userAccessFans = snapshot.data()[userIsAllowedFans];
}
