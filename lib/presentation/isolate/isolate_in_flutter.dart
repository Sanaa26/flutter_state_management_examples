import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IsolateInFlutter extends StatefulWidget {
  const IsolateInFlutter({super.key});

  @override
  State<IsolateInFlutter> createState() => _IsolateInFlutterState();
}

class _IsolateInFlutterState extends State<IsolateInFlutter> {
  String _status = 'Idle';
  String _result = '-';
  bool _isRunning = false;

  Future<void> runHeavyTaskOnMainThread() async {
    setState(() {
      _status = 'Running on Main Thread (UI frozen)...';
      _result = 'Calculating 1,000,000,000 loops';
      _isRunning = true;
    });

    // Short delay to allow UI to render status before freezing
    await Future.delayed(const Duration(milliseconds: 100));

    final stopwatch = Stopwatch()..start();
    final total = await countNumbers();
    stopwatch.stop();

    if (mounted) {
      setState(() {
        _status = 'Main Thread Task Completed';
        _result = 'Result: $total (${stopwatch.elapsedMilliseconds} ms)';
        _isRunning = false;
      });
    }
  }

  void runIsolateTask() async {
    setState(() {
      _status = 'Running in Isolate (UI smooth)...';
      _result = 'Calculating 1,000,000,000 loops in background';
      _isRunning = true;
    });

    final stopwatch = Stopwatch()..start();
    final receivePort = ReceivePort();
    await Isolate.spawn(countNumberWithIsolate, receivePort.sendPort);

    receivePort.listen((message) {
      stopwatch.stop();
      if (mounted) {
        setState(() {
          _status = 'Isolate Task Completed';
          _result = 'Result: $message (${stopwatch.elapsedMilliseconds} ms)';
          _isRunning = false;
        });
      }
      receivePort.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate & Multithreading'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Animation Showcase Container
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'UI Animation Test',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Watch if the animation stutters or freezes during calculation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: Lottie.asset(
                        'assets/ball.json',
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.motion_photos_on_rounded,
                                  size: 60,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                const Text('Animation Active'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status Card
            Card(
              color: _isRunning
                  ? theme.colorScheme.primaryContainer.withOpacity(0.4)
                  : theme.colorScheme.surfaceVariant.withOpacity(0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isRunning
                              ? Icons.hourglass_top_rounded
                              : Icons.check_circle_outline_rounded,
                          color: _isRunning
                              ? theme.colorScheme.primary
                              : Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _status,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _result,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: _isRunning ? null : runHeavyTaskOnMainThread,
                icon: const Icon(Icons.block_rounded, color: Colors.deepOrange),
                label: const Text(
                  'Heavy Task (Main Thread)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.deepOrange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Blocks the UI thread causing the animation to freeze.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _isRunning ? null : runIsolateTask,
                icon: const Icon(Icons.flash_on_rounded),
                label: const Text(
                  'Task with Isolate (Background)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Runs calculation on a separate CPU isolate thread.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> countNumbers() async {
  int count = 0;
  for (int i = 0; i < 1000000000; i++) {
    count++;
  }
  return count;
}

void countNumberWithIsolate(SendPort sendPort) {
  int count = 0;
  for (int i = 0; i < 1000000000; i++) {
    count++;
  }
  sendPort.send(count);
}
