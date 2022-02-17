import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm/pages/add_edit_alarm_page.dart';
import 'package:flutter_alarm/sqflite.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../alarm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Alarm> alarmList = [];
  SlidableController controller = SlidableController();
  DateTime time = DateTime.now();
  final FlutterLocalNotificationsPlugin fulutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initDb() async {
    await DbProvider.setDb();
    alarmList = await DbProvider.getData();
    setState(() {});
  }

  Future<void> reBuild() async {
    alarmList = await DbProvider.getData();
    alarmList.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
    setState(() {});
  }

  void initiaLizeNotification() {
    fulutterLocalNotificationsPlugin.initialize(InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings()
    ));
  }

  void setNotification(int id, DateTime alarmTime) {
    fulutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "アラーム",
        "時間になりました",
        tz.TZDateTime.from(alarmTime, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails('id','name', importance: Importance.max, priority: Priority.high),
            iOS: IOSNotificationDetails()
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );
  }

  Future<void> notification() async {
    fulutterLocalNotificationsPlugin.initialize(InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings()
    ));
    fulutterLocalNotificationsPlugin.show(1, "アラーム", "時間になりました", NotificationDetails(
      android: AndroidNotificationDetails('id','name', importance: Importance.max, priority: Priority.high),
      iOS: IOSNotificationDetails()
    ));
  }

  @override
  void initState() {
    super.initState();
    initDb();
    initiaLizeNotification();
  }

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
                reBuild();
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
                              setState(() async {
                                alarm.isActive = newValue;
                                await DbProvider.updateData(alarm);
                                reBuild();
                              });
                            },

                          ),
                          onTap: () async {
                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAlarmPage(alarmList, index: index)));
                            if (result != null) {
                              setNotification(result.id, result.alarmTime);
                              reBuild();
                            }
                          },
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            icon: Icons.delete,
                            caption: '削除',
                            color: Colors.red,
                            onTap: () async {
                              await DbProvider.deleteData(alarm);
                              reBuild();
                            },
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