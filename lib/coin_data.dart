import 'networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
  'CHF'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const url = 'https://rest.coinapi.io/v1/exchangerate/';
const apikey = '1245';

//https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=73034021
class CoinDataBrain {

  Future<dynamic> getCoinData({targetCurr, baseCurr}) async {
    print(targetCurr);
    print(baseCurr);
    NetworkHelper networkhelper =
        NetworkHelper('$url$baseCurr/$targetCurr?apikey=$apikey');

    var coindData = await networkhelper.getData();
    return coindData;
  }
}
