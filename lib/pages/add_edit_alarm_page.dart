import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm/alarm.dart';
import 'package:intl/intl.dart';

import '../sqflite.dart';

class AddEditAlarmPage extends StatefulWidget {
  final List<Alarm> alarmList;
  final int? index;
  AddEditAlarmPage(this.alarmList, {this.index});

  @override
  _AddEditAlarmPageState createState() => _AddEditAlarmPageState();
}

class _AddEditAlarmPageState extends State<AddEditAlarmPage> {
  TextEditingController controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void initEditAlarm() {
    if (widget.index != null) {
      selectedDate = widget.alarmList[widget.index!].alarmTime;
      controller.text = DateFormat('H:mm').format(selectedDate);
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initEditAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            child: const Text('キャンセル', style: TextStyle(color: Colors.orange)),
          ),
        ),
        actions: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: const Text('保存', style: TextStyle(color: Colors.orange)),
            ),
            onTap: () async {
              Alarm alarm = Alarm(alarmTime: DateTime(2000, 1, 1, selectedDate.hour, selectedDate.minute), isActive: true);

              if (widget.index != null) {
                widget.alarmList[widget.index!] = alarm;
              } else {
                await DbProvider.insertData(alarm);
              }

              Navigator.pop(context);
            },
          )
        ],
        backgroundColor: Colors.black87,
        title: const Text('アラームを追加', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('時間', style: TextStyle(color: Colors.white)),
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.orange),
                      decoration: const InputDecoration(
                        border: InputBorder.none
                      ),
                      readOnly: true,
                      onTap: () {
                        showModalBottomSheet(context: context, builder: (context) {
                          return CupertinoDatePicker(
                            initialDateTime: selectedDate,
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (newDate) {
                              String time = DateFormat('H:mm').format(newDate);
                              selectedDate = newDate;
                              controller.text = time;
                              setState(() { });
                            },
                          );
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
