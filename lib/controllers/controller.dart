import 'dart:math';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:calculadora_de_juros/helpers/constantes.dart';
import 'package:calculadora_de_juros/models/payment_slip.dart';
import 'package:calculadora_de_juros/models/result_payment_slip.dart';

class Controller{
  final moneyController = new MoneyMaskedTextController();
  final feeController = new MoneyMaskedTextController();
  final interestController = new MoneyMaskedTextController();

  final paymentSlip = new PaymentSlip(
    feeType: Constantes.rateLabels[0],
    interestType: Constantes.rateLabels[0],
    interestPeriod: Constantes.periodLabels[0]
  );

  ResultPaymentSlip calculate(){
    ResultPaymentSlip result = ResultPaymentSlip();
    result.value = paymentSlip.money;

    if(paymentSlip.payDate.isAfter(paymentSlip.dueDate)){
      result.fee = _calculateFeeValue();
      result.value += result.fee;
      result.days = paymentSlip.payDate.difference(paymentSlip.dueDate).inDays;
      if(paymentSlip.interestPeriod == Constantes.periodLabels[1]){
        result.days = result.days ~/ 30;
      }
      result.interest = _calculateInterestValues(result.days);
      result.value += result.interest;
    }
    return result; 
  }

  _calculateFeeValue(){

    var value = paymentSlip.feeValue;

    if(paymentSlip.feeType == Constantes.rateLabels[1]){
      value = paymentSlip.feeValue / 100.0 * paymentSlip.money;
    }

    return value;
  }

  _calculateInterestValues(int days){
    double rate = paymentSlip.interestValue / 100.0;
    if(paymentSlip.interestType == Constantes.rateLabels[0]){
      rate = paymentSlip.money * pow(1 + rate, days);
    }
    print('value = ${paymentSlip.money} * (1 + $rate) ^ $days');
    var value = paymentSlip.money * pow(1 + rate, days);
    return value - paymentSlip.money;
  }

  void clear(){}
}