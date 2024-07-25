import 'package:flutter/material.dart';
import 'package:point_of_sale/models/sale.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../api.dart';
import '../common.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Image? image;

class _HomePageState extends State<HomePage> {
  DateTime fromDate = DateTime(2024, 1, 1);
  DateTime toDate = DateTime(2024, 07, 31);
  @override
  Widget build(BuildContext context) {
    // List<PieChartSampleData> data = [
    //   PieChartSampleData('Đơn hoàn trả', 10),
    //   PieChartSampleData('Đơn thành công', 60),
    //   PieChartSampleData('Đơn hủy', 20),
    // ];
    if (sizeController.width < 900) {
      return Column(
        children: [
          Expanded(
            child: Expanded(
              child: FutureBuilder<List<SaleData>>(
                future: Api.fetchDailySalesQuantity(fromDate, toDate),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SaleData>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load sales data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return SfCartesianChart(
                      title: const ChartTitle(
                          text: 'Biểu đồ số lượng hàng bán theo ngày',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          )),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      primaryXAxis: const CategoryAxis(),
                      series: <CartesianSeries<SaleData, String>>[
                        LineSeries<SaleData, String>(
                          animationDuration: 0,
                          dataSource: snapshot.data!,
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              showCumulativeValues: true,
                              useSeriesColor: true),
                          xValueMapper: (SaleData sales, _) => convertDate(sales.saleDate),
                          yValueMapper: (SaleData sales, _) =>
                              sales.totalQuantitySold,
                          name: 'Số lượng',
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Expanded(
              child: FutureBuilder<List<SaleData>>(
                future: Api.fetchDailySalesQuantity(fromDate, toDate),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SaleData>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load sales data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return SfCartesianChart(
                      title: const ChartTitle(
                          text: 'Biểu đồ số lượng hàng bán theo ngày',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          )),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      primaryXAxis: const CategoryAxis(),
                      series: <CartesianSeries<SaleData, String>>[
                        LineSeries<SaleData, String>(
                          animationDuration: 0,
                          dataSource: snapshot.data!,
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              showCumulativeValues: true,
                              useSeriesColor: true),
                          xValueMapper: (SaleData sales, _) => convertDate(sales.saleDate),
                          yValueMapper: (SaleData sales, _) =>
                          sales.totalQuantitySold,
                          name: 'Số lượng',
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      );
    }
  }
}

class PieChartSampleData {
  PieChartSampleData(this.orderType, this.count);

  final String orderType;
  final int count;
}
