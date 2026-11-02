import 'package:flutter/material.dart';

import '../../core/utils/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<_OptionItem> options = [
      _OptionItem(
        title: 'setState - Quotes',
        subtitle: 'Basic Flutter state management using StatefulWidget',
        badge: 'Built-in',
        icon: Icons.refresh_rounded,
        color: Colors.teal,
        route: AppRoutes.setState,
      ),
      _OptionItem(
        title: 'BLoC - Quotes',
        subtitle: 'Event-driven state management with Streams & Events',
        badge: 'BLoC Pattern',
        icon: Icons.account_tree_rounded,
        color: Colors.indigo,
        route: AppRoutes.bloc,
      ),
      _OptionItem(
        title: 'Cubit - Quotes',
        subtitle: 'Simplified BLoC pattern using direct function calls',
        badge: 'BLoC Light',
        icon: Icons.widgets_rounded,
        color: Colors.cyan.shade700,
        route: AppRoutes.cubit,
      ),
      _OptionItem(
        title: 'Provider - Quotes',
        subtitle: 'InheritedWidget wrapper for reactive state management',
        badge: 'InheritedWidget',
        icon: Icons.layers_rounded,
        color: Colors.deepPurple,
        route: AppRoutes.provider,
      ),
      _OptionItem(
        title: 'Riverpod - Quotes',
        subtitle: 'Compile-safe, decoupled state management framework',
        badge: 'Modern',
        icon: Icons.water_drop_rounded,
        color: Colors.blue.shade700,
        route: AppRoutes.riverpod,
      ),
      _OptionItem(
        title: 'GetX - Quotes',
        subtitle: 'High performance reactive state & route manager',
        badge: 'All-in-one',
        icon: Icons.bolt_rounded,
        color: Colors.purple.shade600,
        route: AppRoutes.getx,
      ),
      _OptionItem(
        title: 'Isolate - Heavy Task',
        subtitle: 'Offload intensive computations to background threads',
        badge: 'Multithreading',
        icon: Icons.memory_rounded,
        color: Colors.deepOrange,
        route: AppRoutes.isolateInFlutter,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'State Management Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.architecture_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Patterns',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Compare state management solutions and isolates in Flutter.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Select an Architecture',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Option Cards List
          ...options.map((option) => _buildCard(context, option)),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, _OptionItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, item.route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.badge,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: item.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionItem {
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;
  final String route;

  _OptionItem({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
    required this.route,
  });
}
