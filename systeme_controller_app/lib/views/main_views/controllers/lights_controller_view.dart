import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:systeme_controller_app/utilities/dialogs/error_dialog.dart';

import '../../../services/data_contollers/fans_controller/fans_data_exceptions.dart';
import '../../../services/data_contollers/lights_controller/firebase_lights_storage.dart';
import '../../../services/data_contollers/lights_controller/lights_data_model.dart';


class LightsControllerView extends StatefulWidget {
  LightsControllerView({Key? key}) : super(key: key);

  @override
  State<LightsControllerView> createState() => _LightsControllerViewState();
}

class _LightsControllerViewState extends State<LightsControllerView> {
  late final FirebaseLightsStorage _lights;
  int nb = 0;

  int nbLights(Iterable<LightsDataModel> lightData) {
    int nb = 0;
    for (int i = 0; i < lightData.length; i++) {
      if (lightData.elementAt(i).light == true) {
        nb++;
      }
    }
    return nb;
  }

  @override
  void initState() {
    _lights = FirebaseLightsStorage();
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
          title: const Text('Back'),
        ),
        body: StreamBuilder(
          stream: _lights.light(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('Check your connection'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final lights = snapshot.data as Iterable<LightsDataModel>;
                  int nb = nbLights(lights);
                  return Container(
                    padding: const EdgeInsets.all(30),
                    width: double.maxFinite,
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 450,
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              nb == 0
                                  ? Icons.lightbulb_outline
                                  : Icons.lightbulb,
                              color: nb == 0
                                  ? Colors.black
                                  : const Color.fromARGB(255, 255, 200, 2),
                              size: 150,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: 60,
                              width: 250,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    splashRadius: 25,
                                    onPressed: () async {
                                      try {
                                        if (nb > 0) {
                                        if (lights.elementAt(nb - 1).light ==
                                            true) {
                                          _lights.updateLight(
                                              lightCondition: false,
                                              id: lights
                                                  .elementAt(nb - 1)
                                                  .docId);
                                        }
                                      }
                                        
                                      } on FailedToUpdateLightException {
                                        await showErrorDialog(context, "Failed to light off");
                                      }
                                      

                                      setState(() {
                                        nb = nbLights(lights);
                                      });
                                    },
                                    icon: const Center(
                                      child: Icon(
                                        Icons.remove_circle_outline,
                                        size: 50,
                                        color: Color.fromARGB(255, 255, 30, 0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 50,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 3),
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: Center(
                                          child: Text(
                                        nb.toString(),
                                        style: const TextStyle(fontSize: 40),
                                      ))),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    splashRadius: 25,
                                    onPressed: () async {
                                      try {
                                        if (nb < lights.length) {
                                        if (lights.elementAt(nb).light ==
                                            false) {
                                          _lights.updateLight(
                                              lightCondition: true,
                                              id: lights.elementAt(nb).docId);
                                        }
                                      }
                                      } on FailedToUpdateLightException {
                                        await showErrorDialog(context, "Failed to light up");
                                      }
                                      
                                      

                                      setState(() {
                                        nb = nbLights(lights);
                                      });
                                    },
                                    icon: const Center(
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        size: 50,
                                        color: Color.fromARGB(255, 0, 255, 17),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                log('here4');
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        )
        );
  }
}
