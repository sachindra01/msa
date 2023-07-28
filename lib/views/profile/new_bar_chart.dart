import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Barchart1 extends StatefulWidget {
  const Barchart1({Key? key}) : super(key: key);

  @override
  State<Barchart1> createState() => _Barchart1State();
}

class _Barchart1State extends State<Barchart1> {
  final AuthController _con = Get.put(AuthController());
  int index = 0;
  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    // Future.delayed(const Duration(seconds: 1), () {
    //   _con.getBarInfo();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthController(),
        builder: (context) {
          return Obx(() => _con.isgraphLoading.value == true
              ? Center(child: loadingWidget())
              : _con.barInfo.isEmpty
                  ? const Center(
                      child: Text("該当データがありません"),
                    )
                  : barChartBody(index));
        });
  }

  Widget barChartBody(index) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(
          '1月',
          _con.showBlue == true ? _con.barInfo[index].data[0] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[0] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[0] : 0),
      ChartData(
          '2月',
          _con.showBlue == true ? _con.barInfo[index].data[1] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[1] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[1] : 0),
      ChartData(
          '3月',
          _con.showBlue == true ? _con.barInfo[index].data[2] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[2] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[2] : 0),
      ChartData(
          '4月',
          _con.showBlue == true ? _con.barInfo[index].data[3] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[3] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[3] : 0),
      ChartData(
          '5月',
          _con.showBlue == true ? _con.barInfo[index].data[4] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[4] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[4] : 0),
      ChartData(
          '6月',
          _con.showBlue == true ? _con.barInfo[index].data[5] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[5] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[5] : 0),
      ChartData(
          '7月',
          _con.showBlue == true ? _con.barInfo[index].data[6] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[6] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[6] : 0),
      ChartData(
          '8月',
          _con.showBlue == true ? _con.barInfo[index].data[7] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[7] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[7] : 0),
      ChartData(
          '9月',
          _con.showBlue == true ? _con.barInfo[index].data[8] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[8] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[8] : 0),
      ChartData(
          '10月',
          _con.showBlue == true ? _con.barInfo[index].data[9] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[9] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[9] : 0),
      ChartData(
          '11月',
          _con.showBlue == true ? _con.barInfo[index].data[10] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[10] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[10] : 0),
      ChartData(
          '12月',
          _con.showBlue == true ? _con.barInfo[index].data[11] : 0,
          _con.showGreen == true ? _con.barInfo[index + 1].data[11] : 0,
          _con.showGrey == true ? _con.barInfo[index + 2].data[11] : 0),
    ];
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 10,
              width: 100,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _con.showBlue = !_con.showBlue;
                  index = 0;
                });
              },
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.blue,
                  ),
                  _con.showBlue == false
                      ? Text(
                          _con.barInfo[0].label,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough),
                        )
                      : Text(_con.barInfo[0].label),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _con.showGreen = !_con.showGreen;
                  index == 1;
                });
              },
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: primaryColor,
                  ),
                  _con.showGreen == false
                      ? Text(_con.barInfo[1].label,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough))
                      : Text(_con.barInfo[1].label),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _con.showGrey = !_con.showGrey;
                  index = 2;
                });
              },
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey,
                  ),
                  _con.showGrey == false
                      ? Text(_con.barInfo[2].label,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough))
                      : Text(_con.barInfo[2].label),
                ],
              ),
            ),
          ],
        ),
        Center(
          child: SizedBox(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelPosition: ChartDataLabelPosition.outside,
                interval: 1,
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
                numberFormat: NumberFormat.compact(),
              ),
              enableAxisAnimation: true,
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue),
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y1,
                    color: primaryColor),
                ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y2,
                    color: Colors.grey)
              ]
            )
          )
        ),
      ],
    ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final int? y;
  final int? y1;
  final int? y2;
}
