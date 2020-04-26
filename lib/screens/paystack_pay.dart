import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:provider/provider.dart';


String backendUrl = 'https://api.paystack.co/transaction';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
//String paystackPublicKey = 'pk_test_ace7abfdd52d9bebce70f286b9cee8cd74acedc8';

String paystackSecretKey = 'sk_test_8024ba0a0bc9b5e2d9245e92c72f314c09e28e8c';

String paystackPublicKey = 'pk_live_95c487e82efab6003e54cbeaa7bcf9bfda683f0f';


class PaystackPay extends StatefulWidget
{


  String price, email, type, plan, bouq, iuc, brand, product, month, number;

  PaystackPay({this.price, this.email, this.type, this.plan, this.bouq, this.iuc,
  this.brand, this.product, this.month, this.number});

  @override
  _PaystackPayState createState() => _PaystackPayState();
}

class _PaystackPayState extends State<PaystackPay>
{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  var _border = new Container(
    width: double.infinity,

    height: 1.0,
    color: Colors.red,
  );
  int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  String _reference;

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Center(child: const Text("micgrand pay")),
      )),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
//                    new Expanded(
////                      child: const Text('Initalize transaction from:'),
//                    ),
//                    new Expanded(
//                      child: new Column(
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[
//                            new RadioListTile<int>(
//                              value: 0,
//                              groupValue: _radioValue,
//                              onChanged: _handleRadioValueChanged,
//                              title: const Text('Local'),
//                            ),
//                            new RadioListTile<int>(
//                              value: 1,
//                              groupValue: _radioValue,
//                              onChanged: _handleRadioValueChanged,
//                              title: const Text('Server'),
//                            ),
//                          ]),
//                    )
                  ],
                ),
//                _border,
                _verticalSizeBox,
                new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Card number',
                  ),
                  onSaved: (String value) => _cardNumber = value,
                ),
                _verticalSizeBox,
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'CVV',
                        ),
                        onSaved: (String value) => _cvv = value,
                      ),
                    ),
                    _horizontalSizeBox,
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Expiry Month',
                        ),
                        onSaved: (String value) =>
                        _expiryMonth = int.tryParse(value),
                      ),
                    ),
                    _horizontalSizeBox,
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Expiry Year',
                        ),
                        onSaved: (String value) =>
                        _expiryYear = int.tryParse(value),
                      ),
                    )
                  ],
                ),
                _verticalSizeBox,
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: green,
                    primaryColorLight: Colors.white,
                    primaryColorDark: navyBlue,
                    textTheme: Theme.of(context).textTheme.copyWith(
                      body2: TextStyle(
                        color: lightBlue,
                      ),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      return _inProgress
                          ? new Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Platform.isIOS
                            ? new CupertinoActivityIndicator()
                            : new CircularProgressIndicator(),
                      )
                          : new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _getPlatformButton(
                              'Pay', () => _startAfreshCharge()),
                          _verticalSizeBox,
//                          _border,
                          new SizedBox(
                            height: 40.0,
                          ),
//                          new Row(
//                            mainAxisAlignment:
//                            MainAxisAlignment.spaceBetween,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              new Flexible(
//                                flex: 3,
//                                child: new DropdownButtonHideUnderline(
//                                  child: new InputDecorator(
//                                    decoration: const InputDecoration(
//                                      border: OutlineInputBorder(),
//                                      isDense: true,
//                                      hintText: 'Checkout method',
//                                    ),
//                                    isEmpty: _method == null,
//                                    child: new DropdownButton<
//                                        CheckoutMethod>(
//                                      value: _method,
//                                      isDense: true,
//                                      onChanged: (CheckoutMethod value) {
//                                        setState(() {
//                                          _method = value;
//                                        });
//                                      },
//                                      items: banks.map((String value) {
//                                        return new DropdownMenuItem<
//                                            CheckoutMethod>(
//                                          value:
//                                          _parseStringToMethod(value),
//                                          child: new Text(value),
//                                        );
//                                      }).toList(),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              _horizontalSizeBox,
//                              new Flexible(
//                                flex: 2,
//                                child: new Container(
//                                  width: double.infinity,
//                                  child: _getPlatformButton(
//                                    'Checkout',
//                                        () => _handleCheckout(context),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChanged(int value) =>
      setState(() => _radioValue = value);

  _handleCheckout(BuildContext context) async
  {

    if (_method == null)
    {
      _showMessage('Select checkout method first');
      return;
    }

    if (_method != CheckoutMethod.card && _isLocal) {
      _showMessage('Select server initialization method at the top');
      return;
    }
    setState(() => _inProgress = true);
    _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = int.parse(widget.price) * 100  < 10000 ? int.parse(widget.price) * 100 + 150 : int.parse(widget.price) * 100 + 200 // In base currency
      ..email = widget.email
      ..card = _getCardFromUI();

    if (!_isLocal)
    {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;

      setState(() {
        _reference = charge.reference;
      });
    } else {
      charge.reference = _getReference();
    }

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: MyLogo(),
      );
      print('Response = $response');
      setState(() => _inProgress = false);
      _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => _inProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  _showErrorDialog(String errMessage, String status)
  {
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text(status),
            content: Text(errMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              )
            ],
          );
        }
    );

  }
  _startAfreshCharge() async
  {
    _formKey.currentState.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);



    if (_isLocal)
    {
      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an exception

      charge
        ..amount = 5 * 100// In base currency
        ..email = widget.email
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Micgrand services');
      _chargeCard(charge);
    } else {
      // Perform transaction/initialize on Paystack server to get an access code
      // documentation: https://developers.paystack.co/reference#initialize-a-transaction
      charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

  _chargeCard(Charge charge)
  {
    // This is called only before requesting OTP
    // Save reference so you may send to server if error occurs with OTP
    handleBeforeValidate(Transaction transaction)
    {
      _updateStatus(transaction.reference, 'validating...');
      setState(() {
        _reference = transaction.reference;
      });

    }

    handleOnError(Object e, Transaction transaction)
    {
      // If an access code has expired, simply ask your server for a new one
      // and restart the charge instead of displaying error
      if (e is ExpiredAccessCodeException)
      {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }
      else if (e is AuthenticationException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog("Failed to authenticate your card please", "failed");


        return;
      }
      else if (e is InvalidAmountException)
      {
        setState(() => _inProgress = false);

        _showErrorDialog("Invalid amount", "failed");

        return;
      }
      else if (e is InvalidEmailException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog("Invalid email entered please try again", "failed");

        return;
      }
      else if (e is CardException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog("Card not valid, try again", "failed");


        return;
      }
      else if (e is ChargeException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog("Failed to charge card, please try again", "failed");

        return;
      }
      else if (e is PaystackException)
      {
        setState(() => _inProgress = false);
        _showErrorDialog("Paystack is currently not available, please try again", "failed");
        return;

      }
      else if (e is PaystackSdkNotInitializedException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog("paystack not initialized, try again", "failed");
        return;

      }
      else if(e is ProcessException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog("A transaction is currently processing, please wait till it concludes before attempting a new charge", "failed");
        return;

      }

      if(transaction.reference != null)
      {
        _verifyOnServer(transaction.reference);
//        _showErrorDialog("verifying transaction on server", "failed");
        return;

      }
      else
        {
        setState(() => _inProgress = false);
        _updateStatus(transaction.reference, e.toString());
      }
    }



    // This is called only after transaction is successful
    handleOnSuccess(Transaction transaction) async
    {
      bool response = await _verifyOnServer(transaction.reference);
      if(response)
      {

        try
        {
          if(widget.type == "sub")
          {
            List res = await Provider.of<DatabaseService>(context, listen: false).addSubscription(widget.plan, widget.bouq,
                widget.month, widget.price.toString(), widget.iuc, widget.email, _reference);

            Map<String, dynamic> map;

            for(int i = 0; i < res.length; i++)
            {
              map = res[i];

            }
            if(map['status'] == "fail")
            {
              _showErrorDialog(map['msg'], map['status']);
            }
            else
            {
              _showErrorDialog(map['msg'], map['status']);

            }
          }
          else{
            List res = await Provider.of<DatabaseService>(context, listen: false).addPurchase(widget.brand, widget.product, widget.email,
                widget.number, widget.price.toString(), _reference);

            Map<String, dynamic> map;

            for(int i = 0; i < res.length; i++)
            {
              map = res[i];

            }

            if(map['status'] == "fail")
            {
              _showErrorDialog(map['msg'], map['status']);
            }
            else
            {
              _showErrorDialog(map['msg'], map['status']);
              if(mounted){

              }
            }


          }

        }on PlatformException catch(error)
        {
          _showErrorDialog(error.message, "error");
        }

      }
    }



    PaystackPlugin.chargeCard(context,
        charge: charge,
        beforeValidate: (transaction) => handleBeforeValidate(transaction),
        onSuccess: (transaction) => handleOnSuccess(transaction),
        onError: (error, transaction) => handleOnError(error, transaction),
      );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );


  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = new CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: new Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = new RaisedButton(
        onPressed: function,
        color: Colors.blueAccent,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: new Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async
  {
    String url = '$backendUrl/new-access-code';
    String accessCode;
    try
    {
      print("Access code url = $url");
      http.Response response = await http.get(Uri.encodeFull(url));
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
              ' the backend: $e');
    }

    return accessCode;
  }

  Future<bool> _verifyOnServer(String reference) async
  {
    bool rep;
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
    try {
      http.Response response = await http.get(Uri.encodeFull(url));
      var body = response.body;
//      _updateStatus(reference, body);
      print(body);
      rep = true;

    } catch (e)
    {
//      _updateStatus(
//          reference,
//          'There was a problem verifying your transaction on the server:'
//              '$reference $e');
    print(e);
       rep = false;
    }
    setState(() => _inProgress = false);
    return rep;
  }

  _updateStatus(String reference, String message)
  {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'close',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  bool get _isLocal => _radioValue == 0;
}

var banks = ['Selectable', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
 }


class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "Migrand services",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const Color green = const Color(0xFF3db76d);
const Color lightBlue = const Color(0xFF34a5db);
const Color navyBlue = const Color(0xFF031b33);
