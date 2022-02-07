import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../alarm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Alarm> alarmList = [
    Alarm(alarmTime: DateTime.now()),
    Alarm(alarmTime: DateTime.now()),
    Alarm(alarmTime: DateTime.now()),
    Alarm(alarmTime: DateTime.now())
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Colors.black,
            largeTitle: const Text("アラーム", style: TextStyle(color: Colors.white)),
            trailing: GestureDetector(
              child: const Icon(Icons.add, color: Colors.orange),
              onTap: () {

              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index){
                  Alarm alarm = alarmList[index];
                  return Column(
                    children: [
                      if (index==0) const Divider(color: Colors.grey, height: 1),
                      ListTile(
                        title: Text(
                            DateFormat('H:mm').format(alarm.alarmTime),
                            style: const TextStyle(color: Colors.white, fontSize: 50)
                        ),
                        trailing: CupertinoSwitch(
                          value: true,
                          onChanged: (newValue) {

                          },
                        ),
                      ),
                      const Divider(color: Colors.grey, height: 8)
                    ],
                  );
                },
                childCount: alarmList.length
            ),
          )
        ],
      ),
    );
  }
}