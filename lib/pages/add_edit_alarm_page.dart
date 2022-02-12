import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEditAlarmPage extends StatefulWidget {
  const AddEditAlarmPage({Key? key}) : super(key: key);

  @override
  _AddEditAlarmPageState createState() => _AddEditAlarmPageState();
}

class _AddEditAlarmPageState extends State<AddEditAlarmPage> {
  TextEditingController controller = TextEditingController();

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
            onTap: () {
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
                        //
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
