import 'package:flutter/material.dart';

import '../../core/utils/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Choose State Management',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.setState);
              },
              child: const Text('setState - Quotes'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.provider);
              },
              child: const Text('Provider - Quotes'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.bloc);
              },
              child: const Text('BLoC - Quotes'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.cubit);
              },
              child: const Text('Cubit - Quotes'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.riverpod);
              },
              child: const Text('Riverpod - Quotes'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.getx);
              },
              child: const Text('GetX - Quotes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.isolateInFlutter);
              },
              child: const Text('Isolate - Task'),
            ),
          ],
        ),
      ),
    );
  }
}
