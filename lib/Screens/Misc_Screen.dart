import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MiscScreen extends StatelessWidget {
  const MiscScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAD3C8),
      appBar: AppBar(
        backgroundColor: const Color(0xffDAD3C8),
        title: const Text('Misc'),
      ),
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          print('Yakınlaştırma yapıldı. Odak noktası: ${details.focalPoint}, Ölçek: ${details.scale}');
        },
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              child: charts.BarChart(
                _createSampleData(),
                animate: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('2017', 5),
      OrdinalSales('2018', 25),
      OrdinalSales('2019', 100),
      OrdinalSales('2020', 75),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}