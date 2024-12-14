import 'package:babyshop_hub/CustomeWidget/SideDrawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      drawer: Sidedrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              const Text(
                "Welcome Back, Admin!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 98, 150),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Here are some quick stats and actions for you:",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Dashboard Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardTile(
                    icon: Icons.category,
                    title: "Categories",
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to Categories
                    },
                  ),
                  _buildDashboardTile(
                    icon: Icons.shopping_cart,
                    title: "Orders",
                    color: Colors.blue,
                    onTap: () {
                      // Navigate to Orders
                    },
                  ),
                  _buildDashboardTile(
                    icon: Icons.people,
                    title: "Customers",
                    color: Colors.green,
                    onTap: () {
                      // Navigate to Customers
                    },
                  ),
                  _buildDashboardTile(
                    icon: Icons.analytics,
                    title: "Reports",
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to Reports
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sales Statistics Section
              const Text(
                "Sales Statistics",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 98, 150),
                ),
              ),
              const SizedBox(height: 16),

              // Bar Chart
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 12,
                    barGroups: [
                      _buildBarChartGroup(0, 5, Colors.blue),
                      _buildBarChartGroup(1, 8, Colors.orange),
                      _buildBarChartGroup(2, 6, Colors.green),
                      _buildBarChartGroup(3, 10, Colors.purple),
                    ],
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 30,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Mon');
                              case 1:
                                return const Text('Tue');
                              case 2:
                                return const Text('Wed');
                              case 3:
                                return const Text('Thu');
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Distribution Section
              const Text(
                "Category Distribution",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 98, 150),
                ),
              ),
              const SizedBox(height: 16),

              // Pie Chart
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      _buildPieChartSection(25, Colors.blue, "Electronics"),
                      _buildPieChartSection(35, Colors.orange, "Clothing"),
                      _buildPieChartSection(20, Colors.green, "Toys"),
                      _buildPieChartSection(20, Colors.purple, "Others"),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build dashboard tiles
  Widget _buildDashboardTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build BarChartGroupData
  BarChartGroupData _buildBarChartGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Helper method to build PieChartSectionData
  PieChartSectionData _buildPieChartSection(
      double value, Color color, String title) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: title,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
