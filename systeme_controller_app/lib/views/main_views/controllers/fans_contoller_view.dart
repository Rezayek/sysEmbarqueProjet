import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systeme_controller_app/services/data_contollers/fans_controller/fans_data_constants.dart';
import 'package:systeme_controller_app/services/data_contollers/fans_controller/fans_data_model.dart';
import 'package:systeme_controller_app/services/data_contollers/fans_controller/firebase_fans_storage.dart';
import 'package:systeme_controller_app/widegets/fans_animation.dart';

class FansControllerView extends StatefulWidget {
  const FansControllerView({Key? key}) : super(key: key);

  @override
  State<FansControllerView> createState() => _FansControllerViewState();
}

class _FansControllerViewState extends State<FansControllerView> {
  late final FirebaseFansStorage _fans;
  @override
  void initState() {
    _fans = FirebaseFansStorage();
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
          title: const Text(
        'Back',
        style: TextStyle(fontSize: 23),
      )),
      body: StreamBuilder(
        stream: _fans.fan(),
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
              if (snapshot.hasData && !snapshot.hasError) {
                final fan = snapshot.data as Iterable<FansDataModel>;
                
                return Center(
                  child: Container(
                    height: 450,
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 3.5,
                              offset: Offset(1, 0),
                              color: Color.fromARGB(255, 204, 193, 193))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fan.elementAt(0).isSpinnig
                            ? const FansAnimation()
                            : const Center(
                                child: FaIcon(FontAwesomeIcons.fan,
                                    color: Color.fromARGB(255, 0, 238, 255),
                                    size: 200),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (fan.elementAt(0).isSpinnig) {
                              await _fans.updateFan(
                                  condition: false,
                                  id: fan.elementAt(0).fanId,
                                  fieldName: fanSpinning);
                              await _fans.updateFan(
                                  condition: false,
                                  id: fan.elementAt(0).fanId,
                                  fieldName: fanSpeedMode1);
                              await _fans.updateFan(
                                  condition: false,
                                  id: fan.elementAt(0).fanId,
                                  fieldName: fanSpeedMode2);
                            } else if (fan.elementAt(0).isSpinnig == false) {
                              await _fans.updateFan(
                                  condition: true,
                                  id: fan.elementAt(0).fanId,
                                  fieldName: fanSpinning);
                            }
                            setState(() {});
                          },
                          child: Container(
                              height: 50,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: fan.elementAt(0).isSpinnig
                                      ? const Color.fromARGB(255, 4, 255, 42)
                                      : const Color.fromARGB(255, 254, 53, 53),
                                  borderRadius: BorderRadius.circular(26)),
                              child: Center(
                                  child: Text(
                                fan.elementAt(0).isSpinnig ? 'On' : 'Off',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 65,
                          width: 225,
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (fan.elementAt(0).isSpinnig) {
                                    if (fan.elementAt(0).mode1 == false) {
                                      if (fan.elementAt(0).mode2 == false) {
                                        await _fans.updateFan(
                                            condition: true,
                                            id: fan.elementAt(0).fanId,
                                            fieldName: fanSpeedMode1);
                                      } else {
                                        await _fans.updateFan(
                                            condition: true,
                                            id: fan.elementAt(0).fanId,
                                            fieldName: fanSpeedMode1);
                                        await _fans.updateFan(
                                            condition: false,
                                            id: fan.elementAt(0).fanId,
                                            fieldName: fanSpeedMode2);
                                      }
                                    }
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  height: 55,
                                  width: 95,
                                  decoration: BoxDecoration(
                                      color: fan.elementAt(0).mode1
                                          ? const Color.fromARGB(
                                              255, 51, 255, 0)
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(26)),
                                  child: const Center(
                                    child: Text('Mode 1',
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (fan.elementAt(0).isSpinnig) {
                                    if (fan.elementAt(0).mode2 == false) {
                                      if (fan.elementAt(0).mode1 == false) {
                                        await _fans.updateFan(
                                            condition: true,
                                            id: fan.elementAt(0).fanId,
                                            fieldName: fanSpeedMode2);
                                      } else {
                                        await _fans.updateFan(
                                            condition: false,
                                            id: fan.elementAt(0).fanId,
                                            fieldName: fanSpeedMode1);
                                        await _fans.updateFan(
                                            condition: true,
                                            id: fan.elementAt(0).fanId,
                                            fieldName: fanSpeedMode2);
                                      }
                                    }
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  height: 55,
                                  width: 95,
                                  decoration: BoxDecoration(
                                      color: fan.elementAt(0).mode2
                                          ? const Color.fromARGB(
                                              255, 255, 123, 36)
                                          : const Color.fromARGB(
                                              255, 236, 94, 24),
                                      borderRadius: BorderRadius.circular(26)),
                                  child: const Center(
                                    child: Text('Mode 2',
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
