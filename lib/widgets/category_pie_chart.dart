import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({super.key});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products by Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  // The `sections` property is the key data source for this chart.
                  // It calls the `showingSections()` method below to get its data.
                  sections: showingSections(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DATA HAND-OFF POINT FOR MUBIN & MEHEDI ---
  List<PieChartSectionData> showingSections() {
    // MUBIN-TODO: Your task is to create a method in your new `DashboardService`.
    // This method, for example `getCategoryDistribution()`, will return a Map
    // of dummy data, like: `{'Electronics': 40.0, 'Office': 30.0, ...}`.
    // You will then write the logic here to transform that Map into the list of
    // `PieChartSectionData` widgets that the chart needs to display.
    // This is a key example of the business logic layer preparing data for the UI.

    // MEHEDI-TODO: Your task is to replace Mubin's dummy `getCategoryDistribution`
    // method with a real Firestore query. You will need to read all documents from the
    // 'products' collection and group them by category to calculate the real percentages.
    // The data you fetch will flow through Mubin's logic to dynamically build this chart.

    // For now, as Azrof, I am providing hardcoded dummy data so the UI can be built and tested.
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(color: Colors.blue.shade400, value: 40, title: '40%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows));
        case 1:
          return PieChartSectionData(color: Colors.yellow.shade600, value: 30, title: '30%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows));
        case 2:
          return PieChartSectionData(color: Colors.pink.shade300, value: 15, title: '15%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows));
        case 3:
          return PieChartSectionData(color: Colors.green.shade400, value: 15, title: '15%', radius: radius, titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows));
        default:
          throw Error();
      }
    });
  }
}

