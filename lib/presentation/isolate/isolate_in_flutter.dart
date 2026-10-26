import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IsolateInFlutter extends StatefulWidget {
  const IsolateInFlutter({super.key});

  @override
  State<IsolateInFlutter> createState() => _IsolateInFlutterState();
}

class _IsolateInFlutterState extends State<IsolateInFlutter> {
  void runIsolateTask() async{
    final receivePort = ReceivePort();
    await Isolate.spawn(countNumberWithIsolate, receivePort.sendPort);
    receivePort.listen((message) {
      debugPrint('Received: $message');
      receivePort.close();
  });
        }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Lottie.asset('assets/ball.json'),
        ElevatedButton(onPressed: () async
        {
          final total = await countNumbers();
          debugPrint('Total: $total');
        },
            child: const Text('Heavy task')),
        ElevatedButton(onPressed: runIsolateTask,
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,),
            child: const Text('Task with Isolate'))
      ],
    );
  }
}
Future<int> countNumbers() async{
  int count = 0;
  for(int i = 0; i < 1000000000; i++){
    count++;
  }
  return count;

}
void countNumberWithIsolate( SendPort sendPort){
  int count = 0;
  for(int i = 0; i < 1000000000; i++){
    count++;
  }
  sendPort.send(count);
}

