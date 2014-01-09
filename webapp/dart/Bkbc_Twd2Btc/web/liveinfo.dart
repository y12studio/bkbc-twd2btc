import 'package:polymer/polymer.dart';
import 'package:intl/intl.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';

/**
 * A Polymer click counter element.
 */
@CustomTag('live-info')
class LiveInfo extends PolymerElement {

  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  @observable String twdPerUsd = "0.0";
  @observable String updateTime = "2014-xx";
  @observable String usdPerBtc = "0.0";
  @observable String twdPerBtc = "0.0";
  @observable String twdPerTx = "0.0";
  @observable String inbtc = "0.0";
  @observable String intwd = "0.0";
  @observable String inrisk = "0";
  @observable String calcTwd = "000000.0";
  @observable String calcTwdRaw = "000000.0";
  @observable String calcBtc = "0.00000";
  @observable String calcBtcRaw = "0.00000";
  @observable String amountTwd = "000000.0";
  @observable String amountBtc = "0.00000";
  @observable String btcAddr = "Bitcoin Address Here";
  @observable String qrurl = "bitqr_y12.png";
  String url = "/json/twdbtc.json";
  String urlTest = "testdata/twdbtc.json";
  
  ImageElement qrimg;
 
  String y12_qrurl = "http://blackbananacoin.org/ext/bitqr.php?bid=14EkXBKNQbXgDTFc23NheH1E2FCR9fUyEJ&amount=0.002&message=support_bkbc";

  LiveInfo.created() : super.created() {
    String host = window.location.hostname;
    String port = window.location.port;    
    // dart dev port
    if(port=="3030"){
      url = urlTest;
    }
    loadData();
    qrimg = this.shadowRoot.querySelector('#qrcodeImg');
  }
  
  bool get applyAuthorStyles => true;
  double vtwdPerBtc;

  void loadData() {
    
    // call the web server asynchronously
    Future request = HttpRequest.getString(url).then(onDataLoaded);
  }
  
  void handleBtcChange(Event e, var detail, Node target) {
    double vbtc = double.parse(inbtc);
    double vrisk = double.parse(inrisk);
    double vtwd = vbtc*vtwdPerBtc;
    double rate = 1-(vrisk/100);
    calcTwd = (vtwd*rate).toStringAsFixed(1);
    calcTwdRaw = vtwd.toStringAsFixed(1);
    calcBtc="0.0";
    calcBtcRaw="0.0";
    amountTwd = (vtwd*rate).toStringAsFixed(1);
    amountBtc = vbtc.toString();
    intwd = "0.0";
  }
  
  String getQrUrl() => 'http://blackbananacoin.org/ext/bitqr.php?bid=${btcAddr}&amount=${amountBtc}&message=bkbc_gen';
  
  void handleTwdChange(Event e, var detail, Node target) {
    double vtwd = double.parse(intwd);
    double vrisk = double.parse(inrisk);
    double vbtc = vtwd/vtwdPerBtc;
    double rate = 1+(vrisk/100);
    calcBtc = (vbtc*rate).toStringAsFixed(8);
    calcBtcRaw = vbtc.toStringAsFixed(8);
    calcTwd="0.0";
    calcTwdRaw="0.0";
    amountTwd = vtwd.toStringAsFixed(1);
    amountBtc = (vbtc*rate).toString();
    inbtc = "0.0";
  }
  
  void handleRiskChange(Event e, var detail, Node target) {
    inbtc = "0.0";
    intwd = "0.0";
    calcBtc="0.0";
    calcBtcRaw="0.0";
    calcTwd="0.0";
    calcTwdRaw="0.0";
  }
  
  void handleGenQrCode(Event e, var detail, Node target) {
    qrimg.className='hidden';
    qrurl = getQrUrl();
    print(qrurl);
    var futures = [qrimg.onLoad.first];
    Future.wait(futures).then((_) => qrimg.className='show');
  }
  
  void handleBtcAddrChange(Event e, var detail, Node target) {
    qrimg.className='hidden';
  }
  
  void onDataLoaded(String jsonString) {
    Map data = JSON.decode(jsonString); // parse response text
    double vtwdPerUsd = data["twdPerUsd"];
    double vusdPerBtc = data["usdPerBtc"];
    int timems = data["updateTimeMs"];
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(timems, isUtc: true);
    vtwdPerBtc = vtwdPerUsd*vusdPerBtc;
    twdPerUsd = vtwdPerUsd.toStringAsFixed(2);
    usdPerBtc = vusdPerBtc.toStringAsFixed(2);
    twdPerBtc = vtwdPerBtc.toStringAsFixed(1);
    twdPerTx = (vtwdPerBtc*0.0001).toStringAsFixed(2);
    updateTime = formatter.format(date.toLocal());
  }
}

