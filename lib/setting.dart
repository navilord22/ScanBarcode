//import 'package:flutter/material.dart';
/*
import 'package:get_it/get_it.dart';
import 'package:invo5_kds/utils/navigation.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resize/resize.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../blocs/setting.bloc.dart';
import '../widget/dropdown.text.widget.dart';
*/
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:price_scanner_app/blocs/setting.bloc.dart';
import 'package:price_scanner_app/services/naviagation.service.dart';
import 'vendor/resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dropdown.text.widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingsBlocPage bloc = SettingsBlocPage();
  bool _isArabic = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // save();
    if (!GetIt.instance.isRegistered<NavigationService>()) {
      GetIt.instance
          .registerSingleton<NavigationService>(NavigationService(context));
    }

    bloc = SettingsBlocPage();
  }

  void _showPopUpMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  save() async {
    //final prefs = await SharedPreferences.getInstance();
    if (bloc.deviceName.isNotEmpty) {
      if (bloc.selectedIP.isNotEmpty) {
        await bloc.setSystemVars();
        bloc.goToItemPage();
      }
    } else {
      _showPopUpMessage(context, 'Please enter device name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(40.h),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'setting.connection'.tr(),
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (txt) {
                  bloc.deviceName = txt;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  labelText: 'setting.deviceName'.tr(),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'setting.deviceList'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        iconSize: 30,
                        onPressed: () {
                          bloc.getIpAddress();
                        },
                        icon: const Icon(Icons.refresh)),
                  ],
                ),
                IconButton(
                    iconSize: 30,
                    onPressed: () async {
                      String? customIp = await customIpDialog();
                      if (customIp != null) {
                        bloc.connectToCustom(customIp);
                      }
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
            Expanded(
              child: Container(
                //  color: Colors.red,
                height: 50.h,
                child: StreamBuilder(
                    stream: bloc.ipAddresses.stream,
                    builder: (context, snapshot) {
                      //  return DropdownTextField(
                      //    options: bloc.ipAddresses.value,
                      //    onSelect: (item) {
                      //      //if (item != null)
                      //      bloc.selectedIP = item;
                      //    },
                      //  );
                      return ListView.builder(
                          itemCount: bloc.ipAddresses.value.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () async {
                                bloc.selectedIP = bloc.ipAddresses.value[index];
                                bloc.connect();
                              },
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 204, 204, 204),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  bloc.ipAddresses.value[index],
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ),
            StreamBuilder(
              stream: bloc.errMsg.stream,
              initialData: "",
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  child: Text(bloc.errMsg.value),
                );
              },
            ),
            Switch(
              value: _isArabic,
              onChanged: (value) {
                setState(() {
                  _isArabic = value;
                  context.locale = value ? const Locale('en') : const Locale('ar');
                });
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    child: ElevatedButton(
                  onPressed: () {
                    bloc.connect();
                  },
                  child: const Text(
                    'setting.connect',
                    style: TextStyle(fontSize: 20),
                  ).tr(),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> customIpDialog() async {
    String? filterText;
    return await showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        useRootNavigator: false,
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Dialog(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
              child: Container(
                height: 300,
                width: 400,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'setting.enterCustomIP'.tr(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        // Container(
                        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        //     //margin: const EdgeInsets.symmetric(vertical: 5),
                        //     child: CustomTextField(
                        //         hint: "IP",
                        //         focus: true,
                        //         keyboardType: TextInputType.number,
                        //         callback: (value) {
                        //           filterText = value;
                        //         })),
                        Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20),
                      child: TextField(
                        onChanged: (txt) {
                          filterText = txt;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          labelText: "IP",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 85,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(238, 238, 238, 0.484),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 130,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.w, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  splashColor: Colors.white.withOpacity(0.5),
                                  hoverColor: Colors.white.withOpacity(0.1),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  child: Ink(
                                    child: Center(
                                        child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'setting.cancel'.tr(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            height: 1,
                                            color: Colors.white),
                                      ),
                                    )),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                  },
                                )),
                            Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.w, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue,
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  splashColor: Colors.white.withOpacity(0.5),
                                  hoverColor: Colors.white.withOpacity(0.1),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  child: Ink(
                                    child: Center(
                                        child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'setting.connect'.tr(),
                                        // maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            height: 1.3,
                                            color: Colors.white),
                                      ),
                                    )),
                                  ),
                                  onTap: () async {
                                    // _addItem();
                                    Navigator.of(context).pop(filterText);
                                  },
                                )),
                          ],
                        ))
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const Text("");
        });
  }
}
