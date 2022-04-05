import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systeme_controller_app/services/auth/auth_services.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_bloc.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_event.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/auth_user_data.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/firebase_user_storage.dart';
import 'package:systeme_controller_app/views/main_views/lights_view.dart';
import 'package:systeme_controller_app/views/main_views/qr_view.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  FirebaseUserStorage userData = FirebaseUserStorage();
  String get userId => AuthServices.firebase().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 120,
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.logout), 
              onPressed: (){context.read<AuthBloc>().add(const AuthEventLogOut());},
              ),
              const SizedBox(width: 5,),
              const Text('logOut'),
            ],
          ),
        )
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
          child: Center(
            child: SizedBox(
              height: 500,
              width: 300,
              child: FutureBuilder(
                future: userData.getUserData(userAccountId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(child: Text("check your connection"));
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data as Iterable<AuthUserData>;
                        return Column(
                          crossAxisAlignment:  CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (userData.elementAt(0).userAccessLights ==
                                      false) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QrView(specificSystem: 'lights',)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LightsView()));
                                  }
                                },
                                child:  Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
                                  padding: const EdgeInsets.all(15),
                                  height: 70,
                                  width: 280,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.lightbulb, color:Color.fromARGB(255, 255, 196, 0) , size: 25,),
                                      SizedBox(width: 10,),
                                      Text(
                                        'Lights',
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: Color.fromARGB(255, 255, 196, 0)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          
                          ],
                        );
                      } else {
                        return Container();
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
