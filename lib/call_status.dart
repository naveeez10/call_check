import 'dart:io';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  PhoneStateStatus status = PhoneStateStatus.NOTHING;
  List<CallLogEntry> calllogs = [];
  bool granted = false;

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
    }
  }

  void getdata() async {
    int lastMinute = DateTime.now().millisecondsSinceEpoch - (60000);
    int now = DateTime.now().millisecondsSinceEpoch;
    Iterable<CallLogEntry> entries = await CallLog.query(
      dateFrom: lastMinute,
      dateTo: now,
    );

    if (status == PhoneStateStatus.CALL_ENDED) {
      print('Queried call log entries');
      for (CallLogEntry entry in entries) {
        print('NUMBER     : ${entry.number}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) setStream();
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      setState(() {
        if (event != null) {
          status = event;
          getdata();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone State"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Platform.isAndroid)
              MaterialButton(
                child: const Text("Request permission of Phone"),
                onPressed: !granted
                    ? () async {
                        bool temp = await requestPermission();
                        setState(() {
                          granted = temp;
                          if (granted) {
                            setStream();
                          }
                        });
                      }
                    : null,
              ),
            const Text(
              "Status of call",
              style: TextStyle(fontSize: 24),
            ),
            Icon(
              getIcons(),
              color: getColor(),
              size: 80,
            ),
            // if (status == PhoneStateStatus.CALL_ENDED && calllogs.length != 0)
            //   Text(calllogs[0].number!)
          ],
        ),
      ),
    );
  }

  IconData getIcons() {
    switch (status) {
      case PhoneStateStatus.NOTHING:
        return Icons.clear;
      case PhoneStateStatus.CALL_INCOMING:
        return Icons.add_call;
      case PhoneStateStatus.CALL_STARTED:
        return Icons.call;
      case PhoneStateStatus.CALL_ENDED:
        return Icons.call_end;
    }
  }

  Color getColor() {
    switch (status) {
      case PhoneStateStatus.NOTHING:
      case PhoneStateStatus.CALL_ENDED:
        return Colors.red;
      case PhoneStateStatus.CALL_INCOMING:
        return Colors.green;
      case PhoneStateStatus.CALL_STARTED:
        return Colors.orange;
    }
  }
}
