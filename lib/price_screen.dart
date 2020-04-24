import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownValue = 'USD';
  String targetCurr;
  Map<String, String> targetValue = Map.fromIterable(cryptoList,
    key: (item) => item,
    value: (item) => '0');

  void updateUI(coinData, cryptoCurr) {
    setState(() {
      if (coinData == null) {
        targetCurr = '?';
        targetValue[cryptoCurr] = '0';
      } else {
        targetCurr = coinData['asset_id_quote'];
        double targetValueD = coinData['rate'];
        targetValue[cryptoCurr] = targetValueD.toStringAsFixed(2);
      }
    });
  }

  void getCoinData(targetCurr) async {
    CoinDataBrain coinDataBrain = CoinDataBrain();
    cryptoList.forEach((cryptoCurr) async {
      var coinData = await coinDataBrain.getCoinData(
          targetCurr: targetCurr, baseCurr: cryptoCurr);
      updateUI(coinData, cryptoCurr);
    });
  }

  DropdownButton<String> getAndroidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    currenciesList.forEach((curr) {
      dropDownItems.add(DropdownMenuItem(
        child: Text(curr),
        value: curr,
      ));
    });

    return DropdownButton<String>(
      value: dropDownValue,
      items: dropDownItems,
      onChanged: (value) {
        setState(
          () {
            dropDownValue = value;
            getCoinData(value);
          },
        );
      },
    );
  }

  CupertinoPicker getIosPicker() {
    List<Text> pickerItems = [];
    currenciesList.forEach((curr) {
      pickerItems.add(Text(curr));
    });

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        getCoinData(selectedIndex);
      },
      children: pickerItems,
    );
  }

  List<Card> getCryptoCard() {
    List<Card> cryptoCards = [];

    cryptoList.forEach((element) {
      cryptoCards.add(
          Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 $element = ${targetValue[element]} $targetCurr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
      );
    });

  return cryptoCards;
  }

  Column getCryptoColumn() {
    return Column(
      children:
        getCryptoCard()
    );
  }

  @override
  void initState() {
    super.initState();
    getCoinData('USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: getCryptoColumn(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}
