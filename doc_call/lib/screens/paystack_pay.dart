import 'dart:convert';
import 'dart:io';

import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';


String backendUrl = 'https://api.paystack.co/transaction';


String paystackSecretKey = 'sk_live_8d478f401d0cc6dcda0c562779cb80ea77906d0c';

String paystackPublicKey = 'pk_live_5c4174557d179cea47ba3e1057e3f654d77720fc';


class PaystackPay extends StatefulWidget
{

  String client_email;
  PaystackPay({this.client_email});

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
  int _payValue = 1;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  String _reference;
  int amount;
  int _startPrice = 500;
  List<String> _months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
  String _month;
  final _subscribeFormKey = GlobalKey<FormState>();


  @override
  void initState()
  {
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    super.initState();
    amount = 500;
    print(widget.client_email);
  }

  Widget _buildCheckOut()
  {
      return
        new Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              flex: 3,
              child: new DropdownButtonHideUnderline(
                child: new InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Checkout method',
                  ),
                  isEmpty: _method == null,
                  child: new DropdownButton<
                      CheckoutMethod>(
                    value: _method,
                    isDense: true,
                    onChanged: (CheckoutMethod value) {
                      setState(() {
                        _method = value;
                      });
                    },
                    items: banks.map((String value) {
                      return new DropdownMenuItem<
                          CheckoutMethod>(
                        value:
                        _parseStringToMethod(value),
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            _horizontalSizeBox,
//            new Flexible(
//              flex: 2,
//              child: new Container(
//                width: double.infinity,
//                child: _getPlatformButton(
//                  'Checkout',
//                      () => _handleCheckout(context),
//                ),
//              ),
//            ),
          ],
        );

  }

  _buildMonthsTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 15.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _months.map((String month){
          return DropdownMenuItem(
            value: month,
            child: Text(
              month, style: TextStyle(
                color: Colors.black,
                fontSize: 15.0
            ),
            ),

          );
        }).toList(),
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            labelText: 'No. Of Months',
            labelStyle: TextStyle(fontSize: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            )
        ),
        validator: (input)=>_month == null
            ? "Please Select No. Of Months"
            : null,
        onChanged: (value)
        {
          setState(()
          {
            _month = value;
            amount = _startPrice;
            amount = amount * int.parse(_month);
            print(amount);
          });

        },
        value: _month != null ? _month : null,
      ),

    );
  }

  _buildSubscribeForm()
  {
    return Form(
      key: _subscribeFormKey,
      child: Column(
        children: <Widget>[
          _buildMonthsTF()
        ],
      ),

    );
  }

  Image appLogo = new Image(
      image: new ExactAssetImage("assets/logo.png"),
      height: 40.0,
      width: 40.0,
      alignment: FractionalOffset.center);

  Widget _buildCard()
  {

    return Container(
        child: Column(
          children: <Widget>[
        new TextFormField(
        decoration: const InputDecoration(
            border: const UnderlineInputBorder(),
      labelText: 'Card Number',
    ),
        onSaved: (String value) => _cardNumber = value,
        ),
        SizedBox(height: 10.0),
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
          ],
        ),

    );

  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[

        ],

        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),
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

                    Flexible(
                      child: Text("Amount to pay is #500 per monthly subscription", style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),


                  ],
                ),
//                _border,
                _verticalSizeBox,
                _buildCard(),

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
                        children: <Widget>
                        [
                          SizedBox(height: 5.0),
                          _buildSubscribeForm(),
                          SizedBox(height: 20.0),
                          _payValue == 1 ? _getPlatformButton(
                              'Pay', () => _startAfreshCharge()) : SizedBox.shrink(),
                          _verticalSizeBox,
//                          _border,
                          new SizedBox(
                            height: 40.0,
                          ),

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

  void _handlePayValueChanged(int value)
  {
    setState(() {
       _payValue = value;
       if(_payValue == 0){
         _radioValue = 1;
       }
       else{
         _radioValue = 0;
       }
    });

  }


  _handleCheckout(BuildContext context) async
  {


    if (_method == null)
    {
      _method = CheckoutMethod.bank;
      setState(() {
        _radioValue = 1;
      });
//      _showMessage('Select checkout method first');
      return;
    }

    if (_method != CheckoutMethod.card && _isLocal) {
      _showMessage('Select server initialization method at the top');
      return;
    }
    setState(() => _inProgress = true);
    _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = 500 * 100 // In base currency
      ..email = widget.client_email
      ..card = _getCardFromUI();



    if (!_isLocal)
    {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;


      setState(() {
        _reference = charge.reference;
      });
    }
    else
      {
      charge.reference = _getReference();
    }

    try
    {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: MyLogo(),
      );

      setState(() => _inProgress = false);
//      _updateStatus(response.reference, '$response');




    }
    catch (e) {
      setState(() => _inProgress = false);
//      _showMessage("Check console for error");
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
                onPressed: ()
                {
                  Navigator.pop(context);
                },
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
        ..amount = amount * 100// In base currency
        ..email = widget.client_email
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Genero health');
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
//      _updateStatus(transaction.reference, 'validating...');
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
        print(e.message);

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
//        _updateStatus(transaction.reference, e.toString());
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


            List res = await Provider.of<DatabaseService>(context, listen: false).updatePayment(widget.client_email, amount.toString());

            Map<String, dynamic> map;

            for(int i = 0; i < res.length; i++)
            {
              map = res[i];

            }
            if(map['status'] == "Fail")
            {
              _showErrorDialog(map['msg'], map['status']);
            }
            else
            {
              Navigator.pop(context);
//              _showErrorDialog(map['msg'], map['status']);

            }


        }on PlatformException catch(error)
        {
          _showErrorDialog(error.message, "Error");
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

  String _getReference()
  {
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
    int amounts = amount * 100;
    var map = Map<String, dynamic>();
    map['email'] = widget.client_email;
    map['amount'] = amounts.toString();
    String url = 'https://doctor-on-call247.com/pizza/initialize.php';
    String accessCode;
    try
    {

      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      List result = json.decode(response.body);

      Map<String, dynamic> maps;

      for(int i = 0; i < result.length; i++)
      {
        maps = result[i];

      }
      accessCode = maps['code'];


    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting access code');
    }

    return accessCode;
  }

  Future<String> _fetchAccessCodeFrmServer2() async
  {

    var map = Map<String, dynamic>();
    map['email'] = widget.client_email;
    map['amount'] = amount.toString();
    String url = 'https://mydstvgotvforselfservice.com/new_mobile/pizza/initialize.php';
    String accessCode;
    List result;
    try
    {

      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      result = json.decode(response.body);

      Map<String, dynamic> maps;

      for(int i = 0; i < result.length; i++)
      {
        maps = result[i];

      }
      accessCode = (maps['code']);


      print(result);

    }
    catch (e)
    {
      print(result);
      setState(() => _inProgress = false);
      _updateStatus(
          "error",
          'There was a problem getting access code from server');
    }

    return accessCode;
  }
  Future<bool> _verifyOnServer(String reference) async
  {
    bool rep;
    var map = Map<String, dynamic>();
    map['reference'] = reference;
    _updateStatus(reference, 'Verifying...');
    String url = 'https://doctor-on-call247.com/pizza/verify.php';
    List result;
    try
    {
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      result = json.decode(response.body);
      print(result);
      Map<String, dynamic> maps;

      for(int i = 0; i < result.length; i++)
      {
        maps = result[i];

      }
      if(maps['status'] == "success")
      {
        rep = true;
      }



    }
    catch(e)
    {
      _updateStatus(
          reference,
          'There was a problem verifying your transaction on the server:');

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

var banks = ['Bank'];

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
