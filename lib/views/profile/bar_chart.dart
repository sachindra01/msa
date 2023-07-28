import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa/common/styles.dart';
import 'package:msa/controller/auth_controller.dart';
import 'package:msa/widgets/loading_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Bargraphchart extends StatefulWidget {
  const Bargraphchart({ Key? key, required this.index }) : super(key: key);
  final int index;

  @override
  State<Bargraphchart> createState() => _BargraphchartState();
}

class _BargraphchartState extends State<Bargraphchart> {
  List<ChartSampleData>? chartDatas;

  TooltipBehavior? _tooltipBehavior;
  final AuthController _con = Get.put(AuthController());
  @override
  void initState() {
    _tooltipBehavior =  TooltipBehavior(enable: true, header: '', canShowMarker: false);
    // Future.delayed(const Duration(seconds: 1),() {
    //   // _con.getBarInfo();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;   
    return GetBuilder(
      init: AuthController(),
      builder: (context) {
        return Obx(() => 
          _con.isgraphLoading.value == true
            ? Center(
              child: loadingWidget()
            )
            : _con.barInfo.isEmpty
              ? const Center(
                child: Text("該当データがありません"),
              )
              : barChartBody(index)
        );
      }
    );
  }
    
    List<ColumnSeries<ChartSampleData, String>> _getStackedColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          opacity: 1,
          dataSource: chartDatas!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          color: Colors.blue,
          name: 'Product A'),
      ColumnSeries<ChartSampleData, String>(
          opacity: 0.5,
          dataSource: chartDatas!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          color: primaryColor,
          name: 'Product B'),
      ColumnSeries<ChartSampleData, String>(
        opacity: 0.4,
          dataSource: chartDatas!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          color: Colors.grey,
          name: 'Product C'),
    ];
  }

  barChartBody(index) {
    chartDatas = <ChartSampleData>[
      ChartSampleData(
        x: '1月',
        y:  _con.showBlue == true? _con.barInfo[index].data[0] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[0]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[0] :0.0
      ),
      ChartSampleData(
        x: '2月',
        y:  _con.showBlue == true? _con.barInfo[index].data[1] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[1]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[1] :0.0
      ),
      ChartSampleData(
        x: '3月',
        y:  _con.showBlue == true? _con.barInfo[index].data[2] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[2]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[2] :0.0
      ),
      ChartSampleData(
        x: '4月',
        y:  _con.showBlue == true? _con.barInfo[index].data[3] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[3]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[3] :0.0
      ),
      ChartSampleData(
        x: '5月',
        y:  _con.showBlue == true? _con.barInfo[index].data[4] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[4]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[4] :0.0
      ),
      ChartSampleData(
        x: '6月',
        y:  _con.showBlue == true? _con.barInfo[index].data[5] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[5]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[5] :0.0
      ),
      ChartSampleData(
        x: '7月',
        y:  _con.showBlue == true? _con.barInfo[index].data[6] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[6]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[6] :0.0
      ),
      ChartSampleData(
        x: '8月',
        y:  _con.showBlue == true? _con.barInfo[index].data[7] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[7]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[7] :0.0
      ),
      ChartSampleData(
        x: '9月',
        y:  _con.showBlue == true? _con.barInfo[index].data[8] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[8]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[8] :0.0
      ),
      ChartSampleData(
        x: '10月',
        y:  _con.showBlue == true? _con.barInfo[index].data[9] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[9]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[9] :0.0
      ),
      ChartSampleData(
        x: '11月',
        y:  _con.showBlue == true? _con.barInfo[index].data[10] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[10]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[10] :0.0
      ),
      ChartSampleData(
        x: '12月',
        y:  _con.showBlue == true? _con.barInfo[index].data[11] :0.0,
        yValue: _con.showGreen == true ? _con.barInfo[index+1].data[11]  : 0.0,
        secondSeriesYValue: _con.showGrey == true?_con.barInfo[index+2].data[11] :0.0
      ),
    ];
    return Column(
      children: [
        Row( 
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 10,
              width: 100,
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _con.showBlue =! _con.showBlue;
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
                  _con.showBlue==false?   Text(_con.barInfo[0].label,style: const TextStyle(decoration: TextDecoration.lineThrough),):Text(_con.barInfo[0].label),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _con.showGreen=!_con.showGreen;
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
                    ? Text(
                      _con.barInfo[1].label,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough
                      )
                    )
                    : Text(_con.barInfo[1].label),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _con.showGrey=!_con.showGrey;
                });
              },
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey,
                  ),
                  _con.showGrey==false
                    ? Text(
                      _con.barInfo[2].label,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough
                      )
                    )
                    :Text(_con.barInfo[2].label),
                ],
              ),
            ),
          ],
        ),
        SfCartesianChart(
          enableSideBySideSeriesPlacement: false,
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(
          // majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0.5),
          labelFormat: '{value}',
          numberFormat: NumberFormat.compact(), // (int.parse( '{value}')/100 ).toString() +'k',
          // labelFormat: '{value}000円',
          //  maximum: ,
          //minimum: 0,
          majorTickLines: const MajorTickLines(size: 0)),
          series: _getStackedColumnSeries(),
          tooltipBehavior: _tooltipBehavior,
        ),
      ],
    );
  }
}

formatting(value) {
  double val = double.parse(value)/1000;
  return val.toString();
}


class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final   String? x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}