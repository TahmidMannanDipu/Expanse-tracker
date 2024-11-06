import 'package:expense_tracker/bar%20graph/individual_bar.dart';

class BarData{
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  BarData({required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,});
  List<IndividualBar> barData = [];

  // initialize bar data
void initalizedBarData (){
  barData = [
    IndividualBar(x: 1, y: sunAmount),// sun
    IndividualBar(x: 2, y: monAmount), // mon
    IndividualBar(x: 3, y: tueAmount), // tue
    IndividualBar(x: 4, y: wedAmount), // wed
    IndividualBar(x: 5, y: thuAmount), // thu
    IndividualBar(x: 6, y: friAmount), // fri
    IndividualBar(x: 0, y: satAmount), // sat

  ] ;
}
}