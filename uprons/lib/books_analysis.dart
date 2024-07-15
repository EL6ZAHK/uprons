import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uprons/book.dart';

class BooksAnalysis extends StatefulWidget {
  const BooksAnalysis({Key? key, required this.books}) : super(key: key);
  final List<Book> books;

  @override
  State<BooksAnalysis> createState() => _BooksAnalysisState();
}

class _BooksAnalysisState extends State<BooksAnalysis> {
  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Books Analysis'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
                SizedBox(width: 5),
                Text(
                  'Number of Downloads',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
                SizedBox(width: 5),
                Text(
                  'Number of Views',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 300,
              child: Center(
                child: BarChart(
                  BarChartData(
                      maxY: 50,
                      minY: 0,
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(axisNameWidget: Text('Books')),
                        rightTitles:
                            AxisTitles(axisNameWidget: Text('Quantity')),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (i >= widget.books.length) i = 0;
                              Text text = widget.books[i].title.length > 15
                                  ? Text(widget.books[i].title.substring(0, 15))
                                  : Text(widget.books[i].title);
                              i++;
                              return text;
                            },
                          ),
                        ),
                      ),
                      barGroups: widget.books.map((book) {
                        return BarChartGroupData(
                          x: book.numOfViews,
                          barRods: [
                            BarChartRodData(
                              toY: book.purchases.toDouble(),
                              width: 25,
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.teal,
                            ),
                            BarChartRodData(
                              toY: book.numOfViews.toDouble(),
                              width: 25,
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.amber,
                            )
                          ],
                        );
                      }).toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
