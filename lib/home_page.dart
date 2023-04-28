import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void getdata() async {
    final Iterable<CallLogEntry> cLog = await CallLog.get();
    print('Queried call log entries');
    for (CallLogEntry entry in cLog) {
      print('NUMBER     : ${entry.number}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: getdata,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Container(
          width: 100,
          height: 50,
          alignment: Alignment.center,
          child: const Text("Get call data",
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
      ),
    );
  }
}
