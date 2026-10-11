import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveApp());
}

// Screen category based on width.
String getScreenCategory(double width) {
  if (width < 600) {
    return 'Mobile';
  } else if (width < 1024) {
    return 'Tablet';
  } else {
    return 'Desktop';
  }
}

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Lab 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const ResponsiveDashboard(),
    );
  }
}

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery.
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Responsive Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      // Rebuild the layout when orientation changes.
      body: OrientationBuilder(
        builder: (context, orientation) {
          final category = getScreenCategory(width);

          final orientationName =
              orientation == Orientation.portrait
                  ? 'Portrait'
                  : 'Landscape';

          return LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              // Desktop layout: navigation rail + three columns.
              if (availableWidth >= 1024) {
                return Row(
                  children: [
                    NavigationRail(
                      selectedIndex: 0,
                      onDestinationSelected: (index) {},
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard_outlined),
                          selectedIcon: Icon(Icons.dashboard),
                          label: Text('Dashboard'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.analytics_outlined),
                          selectedIcon: Icon(Icons.analytics),
                          label: Text('Analytics'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Settings'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: _buildDashboardContent(
                        category: category,
                        orientationName: orientationName,
                        width: width,
                        height: height,
                        columns: 3,
                      ),
                    ),
                  ],
                );
              }

              // Mobile and tablet layouts.
              return _buildDashboardContent(
                category: category,
                orientationName: orientationName,
                width: width,
                height: height,
                columns: availableWidth < 600 ? 1 : 2,
              );
            },
          );
        },
      ),

      // Footer.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        color: Colors.indigo,
        child: const Text(
          'Flutter Lab 3 | Responsive UI',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent({
    required String category,
    required String orientationName,
    required double width,
    required double height,
    required int columns,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 600 ? 10.0 : 20.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive information panel.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.indigo.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Screen Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Category: $category $orientationName'),
                    Text(
                      'Screen size: '
                      '${width.toStringAsFixed(0)} × '
                      '${height.toStringAsFixed(0)}',
                    ),
                    Text('Active content columns: $columns'),
                    Text(
                      'Breakpoint: '
                      '${width < 600 ? "Mobile" : width < 1024 ? "Tablet" : "Desktop"}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Expanded allows the grid to use remaining space.
              Expanded(
                child: GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 1 ? 2.0 : 1.25,
                  children: const [
                    DashboardCard(
                      title: 'Students',
                      value: '1,250',
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    DashboardCard(
                      title: 'Courses',
                      value: '24',
                      icon: Icons.menu_book,
                      color: Colors.green,
                    ),
                    DashboardCard(
                      title: 'Projects',
                      value: '86',
                      icon: Icons.assignment,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),

              // Flexible lets this message adapt to available space.
              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Responsive layout is active!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Reusable dashboard card.
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Adapt the card to the available width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final iconSize = constraints.maxWidth < 180 ? 28.0 : 40.0;

        return Card(
          elevation: 3,
          color: color.withValues(alpha: 0.10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: color,
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}