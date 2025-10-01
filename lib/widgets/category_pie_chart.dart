import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/models/user_model.dart';
import '../data/models/dummy_data.dart';
import '../data/services/dashboard_service.dart';
import '../data/services/data_change_notifier.dart';

class CategoryPieChart extends StatefulWidget {
  final UserRole userRole;
  const CategoryPieChart({super.key, required this.userRole});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  Future<Map<String, int>>? _categoryCountsFuture;

  void _refreshData() {
    if (mounted) {
      setState(() {
        _categoryCountsFuture = DashboardService.instance.getCategoryProductCounts();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _categoryCountsFuture = DashboardService.instance.getCategoryProductCounts();
    dataChangeNotifier.addListener(_refreshData);
  }

  @override
  void dispose() {
    dataChangeNotifier.removeListener(_refreshData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Product Categories (${widget.userRole.name})",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Map<String, int>>(
                future: _categoryCountsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No product data available.'));
                  }

                  final categoryCounts = snapshot.data!;
                  final sections = DummyData.categories.map((category) {
                    final count = categoryCounts[category.id] ?? 0;
                    return PieChartSectionData(
                      color: category.color,
                      value: count.toDouble(),
                      title: count.toString(),
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  }).toList();

                  return PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: DummyData.categories.map((category) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: category.color,
                    ),
                    const SizedBox(width: 6),
                    Text(category.name, style: const TextStyle(fontSize: 14)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}