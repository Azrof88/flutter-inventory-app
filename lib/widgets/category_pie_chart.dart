import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/user_model.dart';
import '../../data/models/dummy_data.dart';

class CategoryPieChart extends StatefulWidget {
  final UserRole userRole;

  const CategoryPieChart({super.key, required this.userRole});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // --- DATA HAND-OFF POINT FOR MUBIN & MEHEDI ---

    // MUBIN-TODO: This data calculation logic is a perfect example of what belongs
    // in your business logic layer. Your task is to create a new `DashboardService`
    // (as a Singleton) and create a dummy method inside it, for example:
    // `Future<Map<String, int>> getCategoryCounts()`.
    // This method will perform the calculation below and return the map.
    // This UI widget will then call your service to get the data.
    
    // MEHEDI-TODO: Your task is to replace Mubin's dummy `getCategoryCounts()` method
    // with a real-time stream from Firestore. You will need to fetch all documents
    // from the 'products' collection and then perform this same grouping and counting
    // logic in Dart to produce the live data for the chart.

    final categoryCounts = <String, int>{};
    for (var product in DummyData.products) {
      categoryCounts[product.categoryId] =
          (categoryCounts[product.categoryId] ?? 0) + 1;
    }

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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Product Categories (${widget.userRole.name})",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // This is the static legend. It's responsive because Wrap automatically
            // creates new lines if the content is too wide for the screen.
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
