import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systeme_controller_app/services/auth/auth_services.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_bloc.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_event.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data_constants.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/firebase_user_storage.dart';
import 'package:systeme_controller_app/views/main_views/controllers/fans_contoller_view.dart';
import 'package:systeme_controller_app/views/main_views/controllers/lights_controller_view.dart';
import 'package:systeme_controller_app/views/main_views/qr_view.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final FirebaseUserStorage userData;
  String get userId => AuthServices.firebase().currentUser!.id;

  @override
  void initState() {
    userData = FirebaseUserStorage();
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SizedBox(
        width: 120,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('logOut'),
          ],
        ),
      )),
      body: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
          child: Center(
            child: SizedBox(
              height: 500,
              width: 330,
              child: StreamBuilder(
                stream: userData.userDataStream(),
                builder: (context, snapshot) {
                  sleep(Duration(milliseconds: 1));
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(child: Text("check your connection"));
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    case ConnectionState.active:
                      if (snapshot.hasData && !snapshot.hasError) {
                        final userOwnData =
                            snapshot.data as Iterable<AuthUserData>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(26)),
                              height: 70,
                              width: 320,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (userOwnData
                                              .elementAt(0)
                                              .userAccessLights ==
                                          false) {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                         QrView(specificSystem: "lights")), (Route<dynamic> route) => false);
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LightsControllerView()));
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      padding: const EdgeInsets.all(15),
                                      height: 70,
                                      width: 170,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.lightbulb,
                                                color: Color.fromARGB(
                                                    255, 255, 196, 0),
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Lights',
                                                style: TextStyle(
                                                    fontSize: 28,
                                                    color: Color.fromARGB(
                                                        255, 255, 196, 0)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () async {
                                          if (userOwnData
                                              .elementAt(0)
                                              .userAccessLights) {
                                            log(userId);
                                            await userData.removeAccess(
                                                userAccountId: userOwnData
                                                    .elementAt(0)
                                                    .userDataId,
                                                userAccountAccess: false,
                                                fieldName: userIsAllowedLights);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 45,
                                          width: 125,
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: userOwnData
                                                      .elementAt(0)
                                                      .userAccessLights
                                                  ? const Color.fromARGB(
                                                      255, 0, 255, 94)
                                                  : Colors.grey
                                                      .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(26)),
                                          child: Center(
                                              child: Text(userOwnData
                                                      .elementAt(0)
                                                      .userAccessLights
                                                  ? 'remove Access'
                                                  : 'no Access')),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 70,
                              width: 320,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(26)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (userOwnData
                                              .elementAt(0)
                                              .userAccessFans ==
                                          false) {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                         QrView(specificSystem: "fan")), (Route<dynamic> route) => false);
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const FansControllerView()));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 70,
                                      width: 170,
                                      child: Row(
                                        children: const [
                                          FaIcon(
                                            FontAwesomeIcons.fan,
                                            color: Color.fromARGB(
                                                255, 0, 238, 255),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Fan',
                                            style: TextStyle(
                                                fontSize: 28,
                                                color: Color.fromARGB(
                                                    255, 0, 238, 255)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () async {
                                          if (userOwnData
                                              .elementAt(0)
                                              .userAccessFans) {
                                            await userData.removeAccess(
                                                userAccountId: userOwnData
                                                    .elementAt(0)
                                                    .userDataId,
                                                userAccountAccess: false,
                                                fieldName: userIsAllowedFans);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 45,
                                          width: 125,
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: userOwnData
                                                      .elementAt(0)
                                                      .userAccessFans
                                                  ? const Color.fromARGB(
                                                      255, 0, 255, 94)
                                                  : Colors.grey
                                                      .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(26)),
                                          child: Center(
                                              child: Text(userOwnData
                                                      .elementAt(0)
                                                      .userAccessFans
                                                  ? 'remove Access'
                                                  : 'no Access')),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              super.widget));
                                },
                                icon: const Icon(
                                  Icons.replay,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                  );
                      }

                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          )),
    );
  }
}
