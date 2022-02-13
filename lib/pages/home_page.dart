import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm/pages/add_edit_alarm_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../alarm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Alarm> alarmList = [
    Alarm(alarmTime: DateTime.now(), isActive: true)
  ];

  SlidableController controller = SlidableController();

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
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAlarmPage(alarmList)));
                setState(() {
                  alarmList.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
                });
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
                      Slidable(
                        controller: controller,
                        actionPane: const SlidableScrollActionPane(),
                        child: ListTile(
                          title: Text(
                              DateFormat('H:mm').format(alarm.alarmTime),
                              style: const TextStyle(color: Colors.white, fontSize: 50)
                          ),
                          trailing: CupertinoSwitch(
                            value: alarm.isActive,
                            onChanged: (newValue) {
                              setState(() {
                                alarm.isActive = newValue;
                              });
                            },
                          ),
                        ),
                        secondaryActions: const [
                          IconSlideAction(
                            icon: Icons.delete,
                            caption: '削除',
                            color: Colors.red,
                          )
                        ],
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