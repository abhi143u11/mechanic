import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
Razorpay _razorpay;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet,);
    super.initState();
  }
void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
  print(response.paymentId);

}

void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
  // Do something when payment fails
}

void _handleExternalWallet(ExternalWalletResponse response) {
  // Do something when an external wallet is selected
  print(response.walletName);
}

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  var options = {
    'key': 'rzp_test_K7nwFgKJ6oD387',
    'amount': 100, //in the smallest currency sub-unit.
    'name': 'Azharuddin',
    'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
    'description': 'Make Payment',
    'prefill': {
      'contact': '9999999999',
      'email': 'example@example.com'
    },
    'external':{
      'wallets':['paytm']
    }
  };


void checkout(){
  _razorpay.open(options);
}



@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Container(),
    );
  }



}
