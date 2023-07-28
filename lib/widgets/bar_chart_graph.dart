import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:msa/models/bar_chart_model.dart';

class BarChartGraph extends StatefulWidget {
  final List<BarChartModel> data;

  const BarChartGraph({Key? key, required this.data}) : super(key: key);

  @override
  _BarChartGraphState createState() => _BarChartGraphState();
}

class _BarChartGraphState extends State<BarChartGraph> {
  late List<BarChartModel> _barChartList;

  @override
  void initState() {
    super.initState();
    _barChartList = [
      BarChartModel(month: "Oct"),
      // BarChartModel(month: "Nov"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Financial",
          data: widget.data,
          domainFn: (BarChartModel series, _) => series.year!,
          measureFn: (BarChartModel series, _) => series.financial,
          colorFn: (BarChartModel series, _) => series.color!),
    ];

    return _buildFinancialList(series);
  }

  Widget _buildFinancialList(series) {
    // ignore: unnecessary_null_comparison
    return _barChartList != null
        ? ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(
              color: Colors.white,
              height: 5,
            ),
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _barChartList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height / 2.3,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(_barChartList[index].month!,
                    //         style: const TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 22,
                    //             fontWeight: FontWeight.bold)),
                    //   ],
                    // ),
                    SizedBox(
                        height: 300,
                        child: charts.BarChart(series, animate: true)),
                  ],
                ),
              );
            },
          )
        : const SizedBox();
  }
}
